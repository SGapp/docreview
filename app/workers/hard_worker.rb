class HardWorker

  include Sidekiq::Worker
  def perform(id)
    document = Document.find(id)
    contract = Contract.new(document.attachment.path)
    extractor = BylawsExtractor.new(contract)
    template = BylawsTemplate.new(extractor)
    document.template_path = template.company_report
    puts '*'*50
    puts extractor.name_article
    puts '*'*50
    document.processed!
  end
end