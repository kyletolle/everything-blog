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
        index_template.templates_path
      end
      include_examples 'raises an error about the env var'
    end

    context 'when templates_path is set' do
      include_context 'when templates_path is set'

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

