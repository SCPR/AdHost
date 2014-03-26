require 'spec_helper'

describe PublicController do
  let(:stream_key) { "mp3-44100-48-m" }

  describe 'GET preroll' do
    it "doesn't get inactive campaigns" do
      inactive = create :preroll_campaign, :inactive, output_key: 'kpcclive'

      get :preroll, key: "kpcclive", stream_key: stream_key
      assigns(:campaign).should be_nil
    end

    context "with consistentPreroll" do
      it "returns the first active campaign with the requested key" do
        campaign1 = create :preroll_campaign, :active, output_key: 'kpcclive'
        campaign2 = create :preroll_campaign, :active, output_key: 'kpcclive'

        # Since we're dealing with random campaigns in the controller,
        # let's do this 10 times so we can be reasonably sure that it
        # is grabbing the first one each time.
        10.times do
          get :preroll,
            :consistentPreroll => true,
            :key          => "kpcclive",
            :stream_key   => stream_key,
            :context      => 'hello' # shouldn't change the behavior

          assigns(:campaign).should eq campaign1
        end
      end
    end

    context "with context" do
      it "returns an active campaign with a matching path filter if present" do
        campaign1 = create :preroll_campaign, :active,
          :path_filter => "airtalk",
          :output_key  => "kpcclive"

        campaign2 = create :preroll_campaign, :active,
          :path_filter => nil,
          :output_key  => "kpcclive"

        get :preroll,
          :key          => "kpcclive",
          :stream_key   => stream_key,
          :context      => "airtalk-podcast"

        assigns(:campaign).should eq campaign1
      end

      it "returns an active campaign with no path filter if no matches are found" do
        campaign1 = create :preroll_campaign, :active,
          :path_filter => "airtalk",
          :output_key  => "kpcclive"

        campaign2 = create :preroll_campaign, :active,
          :path_filter => nil,
          :output_key  => "kpcclive"

        get :preroll,
          :key          => "kpcclive",
          :stream_key   => stream_key,
          :context      => "pattmorrison"

        assigns(:campaign).should eq campaign2
      end

      it "matches in a way that lets context variants through" do
        campaign = create :preroll_campaign, :active,
          :path_filter => "offramp",
          :output_key  => "kpcclive"

        get :preroll,
          :key          => "kpcclive",
          :stream_key   => stream_key,
          :context      => "offramp-weekends"

        assigns(:campaign).should eq campaign
      end
    end

    context "with no available campaign" do
      it "returns an empty body and 200 status" do
        get :preroll, key: "kpcclive", stream_key: stream_key

        response.should be_ok
        response.body.should be_empty
      end
    end

    context "with available campaign" do
      it "sends the encoded file if available" do
        campaign = create :preroll_campaign, :active, output_key: "kpcclive"
        encoding = create :mp3_audio_encoding,
          :campaign     => campaign,
          :stream_key   => stream_key

        silence_stream(STDOUT) { encoding.encode }
        get :preroll, key: "kpcclive", stream_key: stream_key

        response.body.should eq File.read(encoding.path, encoding: "ascii-8bit")
      end

      it "sends nothing if the file isn't available" do
        campaign = create :preroll_campaign, :active, output_key: "kpcclive"
        encoding = create :mp3_audio_encoding,
          :campaign     => campaign,
          :stream_key   => stream_key

        # Encoding hasn't happened yet
        get :preroll, key: "kpcclive", stream_key: stream_key

        response.body.should be_empty
        response.should be_ok
      end
    end
  end

  describe 'GET listeners' do
    before do
      Rails.cache.write("adhost:stream_stats",
        JSON.parse(load_fixture("sm_stats.json")))

      Rails.cache.write("adhost:stream_stats:last_cache", Time.now.to_i)
    end

    render_views

    it "returns the listener stats as JSON" do
      get :listeners, format: :xml

      response.headers['Content-Type'].should match /xml/
      # 793 is the total listeners in the fixture
      response.body.should match %r|<STREAMINGPLAYERS>793</STREAMINGPLAYERS>|
      response.body.should match /TSEPOCH/
    end
  end
end

