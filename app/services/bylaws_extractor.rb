class BylawsExtractor
  attr_reader :contract, :content, :articles

  def initialize(contract)
    @contract = contract
    @content = contract.content
    @articles = contract.articles
    @articles_objects = []
    contract.articles.map do |article|
      @articles_objects << Article.new(article)
    end
  end

  def name
    @content[/(^.*?(?=société|Société))/m].strip.gsub(/\s{2}+/, "")
  end

  def form
    @content[/(SAS|SARL|SA|SCI|EURL|SASU|S\.A\.S|S\.A\.R\.L|S\.A|S\.C\.I|E\.U\.R\.L|S\.A\.S\.U)/]
  end

  def designation
    company_designation = ""
    @articles_objects.each do |article|
      company_designation = article.full_article if article.full_article[/(dénomination sociale|DENOMINATION)/]
    end
    company_designation
  end


end