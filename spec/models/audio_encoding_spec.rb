require 'spec_helper'

describe AudioEncoding do
  describe AudioEncoding::EncodingJob do
    describe '::perform' do
      let(:encoding) { create :mp3_audio_encoding }

      it 'encodes the encoding' do
        encoding.path.should be_nil

        silence_stream(STDOUT) do
          AudioEncoding::EncodingJob.perform(encoding.id)
        end

        encoding.reload.path.should be_present
      end
    end
  end


  let(:stream_key) { "mp3-48000-128-m" }

  describe '#path' do
    context 'with fingerprint' do
      it 'returns the path to the audio file' do
        campaign = create :campaign
        encoding = build :aac_audio_encoding,
          :campaign    => campaign,
          :stream_key  => stream_key,
          :fingerprint => "123"

        encoding.path.should eq File.join(
          Rails.application.config.preroller.audio_dir,
          "#{campaign.id}-123.aac")
      end
    end

    context 'without fingerprint' do
      it 'returns nil' do
        encoding = build :audio_encoding,
          :stream_key  => stream_key,
          :fingerprint => nil

        encoding.path.should be_nil
      end
    end
  end

  describe '#encode' do
    let(:campaign) { create :preroll_campaign }

    context 'aac' do
      it "encodes the file and sets the fingerprint on the encoding" do
        encoding = create :aac_audio_encoding, campaign: campaign
        encoding.path.should eq nil
        silence_stream(STDOUT) { encoding.encode }

        encoding.path.should be_present
        File.exists?(encoding.path).should be_true
        File.extname(encoding.path).should eq '.aac'

        encoding.reload.fingerprint.should be_present
      end
    end

    context 'mp3' do
      it "encodes the file and sets the fingerprint on the encoding" do
        encoding = create :mp3_audio_encoding, campaign: campaign
        encoding.path.should eq nil
        silence_stream(STDOUT) { encoding.encode }

        encoding.path.should be_present
        File.exists?(encoding.path).should be_true
        File.extname(encoding.path).should eq '.mp3'
        File.open(encoding.path).size.should be > 0

        encoding.reload.fingerprint.should be_present
      end
    end
  end


  describe 'async encoding' do
    it 'enqueues the encoding after create' do
      encoding = build :audio_encoding,
        :stream_key => stream_key

      Resque.should_receive(:enqueue)
        .with(AudioEncoding::EncodingJob, kind_of(Numeric))

      encoding.save!
    end
  end

  describe "deleting file" do
    it 'destroys the file when destroying the encoding' do
      encoding = create :mp3_audio_encoding
      silence_stream(STDOUT) { encoding.encode }

      # sanity check
      File.exists?(encoding.path).should be_true

      encoding.destroy
      File.exists?(encoding.path).should be_false
    end
  end
end
