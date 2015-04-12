namespace :pesca do
  desc 'Crawl events and push notification'
  task run: :environment do
    Runner.new.run
  end
end
