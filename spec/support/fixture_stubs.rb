module FixtureStubs
  def load_fixture(name)
    path = "#{Rails.root}/spec/fixtures/#{name}"
    File.read(path)
  end

  def load_audio_fixture(filename)
    path = File.open(File.join('spec', 'fixtures', 'audio', filename))
    File.open(path)
  end
end
