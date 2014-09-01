class HardWorker

  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: false

  def perform(id)
    total 100

    at 5
    document = Document.find(id)
    at 20
    contract = Contract.new(document.attachment.path)
    at 45
    extractor = BylawsExtractor.new(contract)
    at 90
    template = BylawsTemplate.new(extractor)
    at 95
    document.template_path = template.company_report
    at 100
    # at 97
    # document.destroy
    # at 100
    puts '*'*50
    puts document.template_path
    puts '*'*50
    document.processed!
  end
end