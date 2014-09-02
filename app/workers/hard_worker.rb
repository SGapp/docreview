class HardWorker

  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: false

  def perform(id)
    total 100

    at 5
    at 6
    at 7
    at 8
    at 9
    at 10
    at 11
    at 12
    at 13
    at 14
    at 15
    document = Document.find(id)
    at 17
    at 18
    at 19
    at 20
    contract = Contract.new(document.attachment.path)
    at 30
    at 32
    at 35
    at 38
    at 40
    at 42
    at 45
    at 47
    at 48
    at 50
    at 52
    at 53
    at 55
    at 57
    at 56
    at 57
    at 58
    at 59
    at 60
    at 61
    at 62
    at 63
    at 64
    at 65
    at 67
    at 68
    at 69
    at 70
    at 75
    at 77
    at 78
    at 80
    at 82
    at 83
    at 85
    at 86
    at 88
    extractor = BylawsExtractor.new(contract)
    at 89
    at 90
    puts "*"*50
    puts extractor.social_decisions
    puts "*"*50
    puts "*"*50
    print extractor.approval
    puts "*"*50
    template = BylawsTemplate.new(extractor)
    at 92
    at 93
    at 94
    at 95
    document.template_path = template.company_report
    at 96
    at 97
    at 98
    at 99
    document.processed!
    at 100
  end
end