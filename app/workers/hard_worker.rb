class HardWorker

  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: false

  def perform(id)
    total 100


    at 15
    document = Document.find(id)
    at 20
    # begin
     contract = Contract.new(document.attachment.path)
    # rescue
    #   document.failed!
    # end
    at 88
    extractor = BylawsExtractor.new(contract)
    at 90
    template = BylawsTemplate.new(extractor)
    at 95
    document.template_path = template.company_report
    at 96
    document.processed!
    at 100
  end
end