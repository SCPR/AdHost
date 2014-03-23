require 'spec_helper'

describe PrerollCampaign do
  describe '::active' do
    it 'gets campaigns which are active' do
      campaign1 = create :campaign, :active
      campaign2 = create :campaign, :inactive

      PrerollCampaign.active.to_a.should eq [campaign1]
    end
  end


  describe '::output_keys_select_collection' do
    it "is an array of all output keys ordered alphabetically" do
      create :preroll_campaign, output_key: "kpcclive"
      create :preroll_campaign, output_key: "podcast"

      PrerollCampaign.output_keys_select_collection
        .should eq ["kpcclive", "podcast"]
    end
  end


  describe '::verify_stream_key' do
    %w(aac-44100-2-1 aac-22050-1-2 aac-24000-2-2
    mp3-44100-64-m mp3-22050-48-s mp3-24000-64-s).each do |key|
      it "is valid for #{key}" do
        PrerollCampaign.verify_stream_key(key).should eq key
      end
    end


    %w(aac-48000-2-1 nope-nope-nope mp3-0-0-s badkey).each do |key|
      it "raises InvalidAudioError for #{key}" do
        -> {
          PrerollCampaign.verify_stream_key(key)
        }.should raise_error PrerollCampaign::InvalidAudioError,
          "Invalid stream key: #{key}"
      end
    end
  end


  describe '#active?' do
    it "is true if it's currently live" do
      campaign = build :preroll_campaign, :active
      campaign.active?.should eq true
    end

    it "if false if it's not live" do
      campaign = build :preroll_campaign, :inactive
      campaign.active?.should eq false
    end

    it "is false if no start or end time" do
      campaign = build :preroll_campaign, starts_at: nil, ends_at: nil
      campaign.active?.should eq false
    end

    it "is true if only end time and we're before it" do
      campaign = build :preroll_campaign, starts_at: nil, ends_at: 1.day.from_now
      campaign.active?.should eq true
    end

    it "is true if only start time and we're after it" do
      campaign = build :preroll_campaign, starts_at: 1.day.ago, ends_at: nil
      campaign.active?.should eq true
    end

    it "is false if only start time and we're before it" do
      campaign = build :preroll_campaign, starts_at: 1.day.from_now, ends_at: nil
      campaign.active?.should eq false
    end

    it "is false if only end time and we're after it" do
      campaign = build :preroll_campaign, starts_at: nil, ends_at: 1.day.ago
      campaign.active?.should eq false
    end
  end


  describe '#file_for_stream_key' do
    let(:campaign) { create :preroll_campaign }
    let(:encoding) do
      create :audio_encoding,
        :campaign    => campaign,
        :stream_key  => "mp3-44100-64-m",
        :fingerprint => 'fake'
    end

    it "returns the path for the requested encoding if it exists" do
      encoding.path.should be_present
      campaign.file_for_stream_key("mp3-44100-64-m").should eq encoding.path
    end

    it "creates the encoding if it doesn't exist yet" do
      campaign.encodings.count.should eq 0
      campaign.file_for_stream_key('mp3-44100-64-s')
      campaign.encodings.count.should eq 1
    end

    it 'returns nil if the requested encoding does not exist yet' do
      campaign.file_for_stream_key("mp3-44100-64-s").should be_nil
    end

    it 'verifies the stream key and raises if invalid' do
      -> {
        campaign.file_for_stream_key("nope-nope-nope")
      }.should raise_error PrerollCampaign::InvalidAudioError,
        "Invalid stream key: nope-nope-nope"
    end
  end

  describe 'clearing encodings' do
    let(:campaign) { create :preroll_campaign }

    before do
      campaign.encodings.create(stream_key: "mp3-44100-64-m")
      campaign.encodings(true).should be_present
    end

    it 'clears all the existing encodings when changing the master file' do
      campaign.master_file = load_audio_fixture('burst1sec.mp3')
      campaign.save!
      campaign.encodings(true).should_not be_present
    end

    it "doesn't clear the encodings if the master file didn't change" do
      campaign.title = "New Title"
      campaign.save!
      campaign.encodings(true).should be_present
    end
  end
end
