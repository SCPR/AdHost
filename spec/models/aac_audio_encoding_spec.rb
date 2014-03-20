require 'spec_helper'

describe AACAudioEncoding do
  let(:encoding) { build :aac_audio_encoding, stream_key: 'aac-44100-2-1' }
  subject { encoding }

  its(:profile) { should eq 2 }
  its(:bitrate) { should be_nil }
  its(:codec) { should eq 'aac' }
  its(:extension) { should eq 'mp4' }
  its(:channels) { should eq 1 }
  its(:sample_rate) { should eq 44100 }
end
