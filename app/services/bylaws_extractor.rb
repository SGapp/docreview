class BylawsExtractor
  attr_reader :contract, :content, :articles

  def initialize(contract)
    @contract = contract
    @content = contract.content
    @articles = contract.articles
    contract.articles.map do |article|
      Article.new(article)
    end
  end

  def name
    @content[/(^.*?(?=société|Société))/m].strip.gsub(/\s{2}+/, "")
  end

end