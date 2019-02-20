require 'spec_helper'
require './lib/everything/blog/fog_config'

describe Everything::Blog::FogConfig do
  describe '#to_h' do
    describe 'provider key' do
      it 'is included'
      it 'matches the #provider value'
    end

    describe 'aws_access_key_id key' do
      it 'is included'
      it 'matches the #aws_access_key_id value'
    end

    describe 'aws_secret_access_key key' do
      it 'is included'
      it 'matches the #aws_secret_access_key value'
    end

    describe 'region key' do
      it 'is included'
      it 'matches the #region value'
    end

    describe 'path_style key' do
      it 'is included'
      it 'matches the #path_style value'
    end
  end

  describe '#provider' do
    it "is 'AWS'"
  end

  describe '#aws_access_key_id' do
    it 'is the value of the matching environment variable'
  end

  describe '#aws_secret_access_key' do
    it 'is the value of the matching environment variable'
  end

  describe '#aws_storage_bucket' do
    it 'is the value of the matching environment variable'
  end

  describe '#region' do
    it 'is the value of the matching environment variable'
  end

  describe '#path_style' do
    it 'is true'
  end
end
