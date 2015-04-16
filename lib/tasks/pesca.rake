namespace :pesca do
  desc 'Crawl events and push notification'
  task run: :environment do
    Runner.new.run
  end

  desc 'Prepare events data'
  task prepare: :environment do
    runner = Runner.new
    def runner.new_arrival?
      false
    end
    runner.run
  end
end
