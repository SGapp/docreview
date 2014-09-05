class HardWorker

  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: false

  def perform(id)
    total 100


    at 15
    document = Document.find(id)
    at 20
    contract = Contract.new(document.attachment.path)
    at 88
    extractor = Extractors::Bylaws.new(contract)
    at 90
    template = BylawsTemplate.new(extractor, TEMPLATES['bylaws']['mapping'])
    at 92
    template.company_report
    at 95
    document.template_path = template.tmp_file_path
    at 96
    document.processed!
    at 100
  end
end