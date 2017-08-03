require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index_template'

describe Everything::Blog::Output::IndexTemplate do
  let(:given_content_html) do
    ''
  end
  let(:given_template_context) do
    {}
  end
  let(:index_template) do
    described_class.new(given_content_html, given_template_context)
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

  describe '#template_context' do
    it 'is a method' do
      expect(index_template).to respond_to(:template_context)
    end
  end

  describe '#templates_path' do
    context 'when the env var is not set' do
      before do
        ENV.delete('TEMPLATES_PATH')
      end

      it 'raises an error that the env var is not set' do
        expect{index_template.templates_path}.to raise_error(NameError)
      end
    end

    context 'when the env var is set' do
      let(:fake_templates_path) do
        '/some/fake/path'
      end

      before do
        ENV['TEMPLATES_PATH'] = fake_templates_path
      end

      it 'returns the environment var' do
        expect(index_template.templates_path).to eq(fake_templates_path)
      end
    end
  end

  describe '#template_path' do

  end
end

