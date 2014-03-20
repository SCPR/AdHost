require 'spec_helper'

describe MP3AudioEncoding do
  let(:encoding) { build :mp3_audio_encoding, stream_key: 'mp3-44100-128-s' }
  subject { encoding }

  its(:profile) { should be_nil }
  its(:bitrate) { should eq 128 }
  its(:codec) { should eq 'mp3' }
  its(:extension) { should eq MP3AudioEncoding::EXTENSION }
  its(:channels) { should eq 2 }
  its(:sample_rate) { should eq 44100 }
end
