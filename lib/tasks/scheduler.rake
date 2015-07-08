task :scheduler => [:environment] do
  scheduler = Rufus::Scheduler.new

  # Go!
  puts "Scheduler running."
  scheduler.join
end