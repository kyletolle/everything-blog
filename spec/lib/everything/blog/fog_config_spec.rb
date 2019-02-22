require 'spec_helper'
require './lib/everything/blog/fog_config'
require './spec/support/shared'

describe Everything::Blog::FogConfig do
  let(:fog_config) do
    described_class.new
  end

  describe '#to_h' do
    include_context 'with fake aws_access_key_id env var'
    include_context 'with fake aws_secret_access_key env var'
    include_context 'with fake aws_storage_bucket env var'
    include_context 'with fake aws_storage_region env var'

    describe 'provider key' do
      it 'is included' do
        expect(fog_config.to_h).to have_key(:provider)
      end

      it 'matches the #provider value' do
        expect(fog_config.to_h[:provider]).to eq(fog_config.provider)
      end
    end

    describe 'aws_access_key_id key' do
      it 'is included' do
        expect(fog_config.to_h).to have_key(:aws_access_key_id)
      end

      it 'matches the #aws_access_key_id value' do
        expect(fog_config.to_h[:aws_access_key_id])
          .to eq(fog_config.aws_access_key_id)
      end
    end

    describe 'aws_secret_access_key key' do
      it 'is included' do
        expect(fog_config.to_h).to have_key(:aws_secret_access_key)
      end

      it 'matches the #aws_secret_access_key value' do
        expect(fog_config.to_h[:aws_secret_access_key])
          .to eq(fog_config.aws_secret_access_key)
      end
    end

    describe 'region key' do
      it 'is included' do
        expect(fog_config.to_h).to have_key(:region)
      end

      it 'matches the #aws_storage_region value' do
        expect(fog_config.to_h[:region]).to eq(fog_config.aws_storage_region)
      end
    end

    describe 'path_style key' do
      it 'is included' do
        expect(fog_config.to_h).to have_key(:path_style)
      end

      it 'matches the #path_style value' do
        expect(fog_config.to_h[:path_style]).to eq(fog_config.path_style)
      end
    end
  end

  describe '#provider' do
    it "is 'AWS'" do
      expect(fog_config.provider).to eq('AWS')
    end
  end

  describe '#aws_access_key_id' do
    include_context 'with fake aws_access_key_id env var'

    it 'is the value of the matching environment variable' do
      expect(fog_config.aws_access_key_id).to eq(fake_env_value)
    end
  end

  describe '#aws_secret_access_key' do
    include_context 'with fake aws_secret_access_key env var'

    it 'is the value of the matching environment variable' do
      expect(fog_config.aws_secret_access_key).to eq(fake_env_value)
    end
  end

  describe '#aws_storage_bucket' do
    include_context 'with fake aws_storage_bucket env var'

    it 'is the value of the matching environment variable' do
      expect(fog_config.aws_storage_bucket).to eq(fake_env_value)
    end
  end

  describe '#aws_storage_region' do
    include_context 'with fake aws_storage_region env var'

    it 'is the value of the matching environment variable' do
      expect(fog_config.aws_storage_region).to eq(fake_env_value)
    end
  end

  describe '#path_style' do
    it 'is true' do
      expect(fog_config.path_style).to eq(true)
    end
  end
end
