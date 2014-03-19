FactoryGirl.define do
  factory :user do
    name "Bryan Ricker"
    sequence(:username) { |n| "bricker#{n}" }
    password "secret"
    password_confirmation { password }

    sequence(:email) { |i| "user#{i}@scpr.org" }

    can_login 1
    is_superuser 1
  end

  factory :visual_campaign do
    title "Pledge Drive"
    sequence(:output_key) { |n| "pledge-pushdown-#{n}" }
    markup "<div>Money</div>"
    domains "scpr.org,scprdev.org"

    trait :active do
      starts_at { 1.day.ago }
      ends_at { 1.day.from_now }
    end

    trait :inactive do
      starts_at { 2.days.ago }
      ends_at { 1.day.ago }
    end

    trait :invalid do
      title ""
    end
  end

  factory :audio_encoding do
    campaign
  end

  factory :aac_audio_encoding, class: "AACAudioEncoding" do
    campaign
    stream_key "aac-44100-2-1"
  end

  factory :mp3_audio_encoding, class: "MP3AudioEncoding" do
    campaign
    stream_key "mp3-44100-48-m"
  end


  factory :preroll_campaign, aliases: [:campaign] do
    sequence(:title) { |n| "Campaign Title #{n}" }
    output_key "kpcclive"

    master_file Rack::Test::UploadedFile.new(
      File.open("spec/fixtures/audio/burst1sec.mp3"), "audio/mpeg")

    trait :active do
      starts_at { 1.day.ago }
      ends_at { 1.day.from_now }
    end

    trait :inactive do
      starts_at { 2.days.ago }
      ends_at { 1.day.ago }
    end

    trait :invalid do
      title ""
    end

  end
end
