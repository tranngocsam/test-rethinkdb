class ReportWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts 'Doing hard work'
  end
end