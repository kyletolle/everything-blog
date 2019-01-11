require './lib/everything/blog/output/post_template'

describe Everything::Blog::Output::PostTemplate do
  # TODO: Start fleshing out this spec.

  let(:given_content_html) do
    ''
  end
  let(:given_template_context) do
    {}
  end
  let(:post_template) do
    described_class.new(given_content_html, given_template_context)
  end

  it 'has a TEMPLATE_NAME constant' do
    expect(described_class).to have_constant(:TEMPLATE_NAME)
  end

  describe '#template_name' do
    it 'is the TEMPLATE_NAME constant' do
      expect(post_template.template_name).to eq(described_class::TEMPLATE_NAME)
    end
  end
end
