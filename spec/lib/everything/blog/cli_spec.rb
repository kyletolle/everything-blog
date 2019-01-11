require './lib/everything/blog/cli'
describe Everything::Blog::CLI do
  describe '#generate' do
    let(:given_cli_arguments) do
      ['generate']
    end
    let(:cli) do
      described_class.start(given_cli_arguments)
    end

    it "calls blog's generate_site" do
      expect_any_instance_of(Everything::Blog).to receive(:generate_site)

      cli
    end
  end
end
