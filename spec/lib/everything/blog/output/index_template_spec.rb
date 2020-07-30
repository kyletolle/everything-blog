require 'spec_helper'

describe Everything::Blog::Output::IndexTemplate do
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

  describe '#inspect' do
    include_context 'stub out templates path'

    let(:inspect_output_regex) do
      /#<#{described_class}: template_path: `#{index_template.template_path}`, template_name: `#{index_template.template_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(index_template.inspect).to match(inspect_output_regex)
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

      let(:action) do
        Everything::Blog::Output.templates_dir
      end
      include_examples 'raises an error about the env var'
    end

    context 'when templates_path is set' do
      include_context 'stub out templates path'

      context 'when an index template does not exist' do
        let(:action) do
          index_template.merge_content_and_template
        end

        include_examples 'raises an error for template not existing'
      end

      context 'when an index template exists' do
        include_context 'with an index template'

        let(:given_template) do
          index_template
        end
        include_context 'with a fake template file'

        include_examples 'renders the template with Tilt'
      end
    end
  end

  let(:given_template) do
    index_template
  end
  include_examples 'behaves like a TemplateBase'
end

