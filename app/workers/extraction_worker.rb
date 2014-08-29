class ExtractionWorker
  include Sidekiq::Worker
  def perform(id)
    document = Document.find(id)
    document.destroy
  end
end