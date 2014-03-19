### Guard::Resque
#  available options:
#  - :task (defaults to 'resque:work' if :count is 1; 'resque:workers', otherwise)
#  - :verbose / :vverbose (set them to anything but false to activate their respective modes)
#  - :trace
#  - :queue (defaults to "*")
#  - :count (defaults to 1)
#  - :environment (corresponds to RAILS_ENV for the Resque worker)
guard 'resque', task: 'environment resque:work', environment: 'development' do
  watch(%r{^app/(.+)\.rb$})
  watch(%r{^lib/(.+)\.rb$})
  watch(%r{^config/(.+)\.rb$})
end

guard :rspec, cli: "-c -f progress --fail-fast", all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }
end
