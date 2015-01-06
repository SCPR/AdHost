task :scheduler => [:environment] do
  scheduler = Rufus::Scheduler.new

  scheduler.every '1m' do |job|
    StreamStats.cache()
  end

  # Go!
  puts "Scheduler running."
  scheduler.join
end