require 'rails_helper'

RSpec.describe Conversion::Params do
  let(:dummy_class) { Class.new { include Conversion::Params } }

  it '.image_param_keys' do
    expect(dummy_class.new.image_param_keys).to be_a Array 
    expect(dummy_class.new.image_param_keys.count).to eq 19
  end

  it '.video_param_keys' do
    expect(dummy_class.new.video_param_keys).to be_a Array 
    expect(dummy_class.new.video_param_keys.count).to eq 10
  end

  it '.audio_param_keys' do
    expect(dummy_class.new.audio_param_keys).to be_a Array 
    expect(dummy_class.new.audio_param_keys.count).to eq 3
  end
end