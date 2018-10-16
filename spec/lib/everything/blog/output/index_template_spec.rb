require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index_template'
require 'fakefs/spec_helpers'
require './spec/support/shared'

describe Everything::Blog::Output::IndexTemplate do
  include FakeFS::SpecHelpers

  include_context 'with fakefs'

  let(:given_content_html) do
    ''
  end
  let(:given_template_context) do
    {}
  end
  let(:index_template) do
    described_class.new(given_content_html, given_template_context)
  end

  shared_context 'when templates_path is not set' do
    # TODO: Is there a better way to test this stuff than actually setting and
    # deleting env vars?
    before do
      @original_templates_path = ENV['TEMPLATES_PATH']
      ENV.delete('TEMPLATES_PATH')
    end

    after do
      ENV['TEMPLATES_PATH'] = @original_templates_path
    end
  end

  shared_context 'when templates_path is set' do
    let(:given_templates_path) do
      '/some/fake/path'
    end

    # TODO: Is there a better way to test this stuff than actually setting and
    # deleting env vars?
    before do
      @original_templates_path = ENV['TEMPLATES_PATH']
      ENV['TEMPLATES_PATH'] = given_templates_path
    end

    after do
      ENV['TEMPLATES_PATH'] = @original_templates_path
    end
  end

  shared_examples 'raises an error about the env var' do
    it 'raises an error that the env var is not set' do
      # TODO: Should this raise a better named error?
      expect{index_template.templates_path}.to raise_error(NameError)
    end
  end

  describe '#initialize' do
    context 'when content_html is not given' do
      let(:index_template) do
        described_class.new
      end

      it 'raises an ArgumentError' do
        expect{index_template}.to raise_error(ArgumentError)
      end
    end

    context 'when content_html is given' do
      context 'when template_context is not given' do
        let(:index_template) do
          described_class.new(given_content_html)
        end

        it 'raises no ArgumentError' do
          expect{index_template}.not_to raise_error
        end

        it 'sets the content_html attr' do
          expect(index_template.content_html).to eq(given_content_html)
        end
      end

      context 'when template_context is given' do
        let(:index_template) do
          described_class.new(given_content_html, given_template_context)
        end

        it 'raises no ArgumentError' do
          expect{index_template}.not_to raise_error
        end

        it 'sets the content_html attr' do
          expect(index_template.content_html).to eq(given_content_html)
        end

        it 'sets the template_context attr' do
          expect(index_template.template_context).to eq(given_template_context)
        end
      end
    end
  end

  describe '#content_html' do
    it 'is a method' do
      expect(index_template).to respond_to(:content_html)
    end
  end

  describe '#merge_content_and_template' do
    let(:given_content_html) do
      "<p>Hi.</p>"
    end
    let(:given_template_context) do
      {
        fake: :context
      }
    end

    context 'when templates_path is not set' do
      include_context 'when templates_path is not set'

      include_examples 'raises an error about the env var'
    end

    context 'when templates_path is set' do
      include_context 'when templates_path is set'

      context 'when an index template does not exist' do
        let(:action) do
          index_template.merge_content_and_template
        end

        include_examples 'raises an error for index template not existing'
      end

      context 'when an index template exists' do
        include_context 'with an index template'

        before do
          FileUtils.mkdir_p(index_template.templates_path)
          File.write(index_template.template_path, '')
        end

        it 'passes the template_path to Tilt' do
          allow(Tilt)
            .to receive(:new)
            .with(index_template.template_path)
            .and_call_original

          index_template.merge_content_and_template

          expect(Tilt).to have_received(:new).with(index_template.template_path)
        end

        it 'renders using the given template_context' do
          fake_erb_template = double(Tilt::ERBTemplate)

          allow(Tilt)
            .to receive(:new)
            .and_return(fake_erb_template)
          allow(fake_erb_template)
            .to receive(:render)
            .with(given_template_context)

          index_template.merge_content_and_template

          expect(fake_erb_template)
            .to have_received(:render)
            .with(given_template_context)
        end

        it 'renders using the given content_html' do
          fake_erb_template = double(Tilt::ERBTemplate)

          allow(Tilt)
            .to receive(:new)
            .and_return(fake_erb_template)

          # Note: Found this helpful approach to verify the block value:
          # https://stackoverflow.com/a/31996525/249218
          expect(fake_erb_template)
            .to receive(:render) do |&block|
              expect(block.call).to eq(given_content_html)
          end

          index_template.merge_content_and_template
        end
      end
    end
  end

  describe '#template_context' do
    it 'is a method' do
      expect(index_template).to respond_to(:template_context)
    end
  end

  it 'has a TEMPLATE_NAME constant' do
    expect(described_class).to have_constant(:TEMPLATE_NAME)
  end

  describe '#template_name' do
    it 'is the TEMPLATE_NAME constant' do
      expect(index_template.template_name).to eq(described_class::TEMPLATE_NAME)
    end
  end

  describe '#template_path' do
    context 'when templates_path is not set' do
      include_context 'when templates_path is not set'

      include_examples 'raises an error about the env var'
    end

    context 'when templates_path is set' do
      include_context 'when templates_path is set'

      let(:expected_template_path) do
        File.join('', 'some', 'fake', 'path', described_class::TEMPLATE_NAME)
      end

      it 'is the template under the templates_path' do
        expect(index_template.template_path).to eq(expected_template_path)
      end
    end
  end

  describe '#templates_path' do
    context 'when the env var is not set' do
      include_context 'when templates_path is not set'

      it 'raises an error that the env var is not set' do
        expect{index_template.templates_path}.to raise_error(NameError)
      end
    end

    context 'when the env var is set' do
      include_context 'when templates_path is set'

      it 'returns the environment var' do
        expect(index_template.templates_path).to eq(given_templates_path)
      end
    end
  end

  describe '#template_path' do
    context 'when the templates_path is not set' do
      include_context 'when templates_path is not set'

      it 'raises a NameError' do
        expect{ index_template.template_path }.to raise_error(NameError)
      end
    end

    context 'when the templates_path is set' do
      include_context 'when templates_path is set'

      it 'is the path for the template' do
        expect(index_template.template_path).to eq('/some/fake/path/index.html.erb')
      end
    end
  end
end

