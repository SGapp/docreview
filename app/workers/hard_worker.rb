class HardWorker

  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    document = Document.find(id)
    contract = Contract.new(document.attachment.path)
    extractor = BylawsExtractor.new(contract)
    template = BylawsTemplate.new(extractor)
    document.template_path = template.company_report
    puts '*'*50
    puts document.template_path
    puts '*'*50
    document.processed!
  end
end