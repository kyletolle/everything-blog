require 'spec_helper'
require 'fakefs/spec_helpers'

describe Everything::Blog::Output::PostTemplate do
  include FakeFS::SpecHelpers

  include_context 'with fakefs'

  let(:given_content_html) do
    ''
  end
  let(:given_template_context) do
    {}
  end
  let(:post_template) do
    described_class.new(given_content_html, given_template_context)
  end

  describe '#inspect' do
    include_context 'stub out templates path'

    let(:inspect_output_regex) do
      /#<#{described_class}: template_path: `#{post_template.template_path}`, template_name: `#{post_template.template_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(post_template.inspect).to match(inspect_output_regex)
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
        post_template.templates_path
      end
      include_examples 'raises an error about the env var'
    end

    context 'when templates_path is set' do
      include_context 'stub out templates path'

      context 'when a post template does not exist' do
        let(:action) do
          post_template.merge_content_and_template
        end

        include_examples 'raises an error for template not existing'
      end

      context 'when a post template exists' do
        include_context 'with a post template'

        let(:given_template) do
          post_template
        end
        include_context 'with a fake template file'

        include_examples 'renders the template with Tilt'
      end
    end
  end

  let(:given_template) do
    post_template
  end
  include_examples 'behaves like a TemplateBase'
end

