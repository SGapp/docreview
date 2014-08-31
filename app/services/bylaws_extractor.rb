class BylawsExtractor
  attr_reader :contract, :content, :articles

  def initialize(contract)
    @contract = contract
    @content = contract.content
    @articles = contract.articles
    @article_objects = []
    contract.articles.map do |article|
      @article_objects << Article.new(article)
    end
  end

  def name
    @content[/(^.*?(?=société|Société|au capital|siège social))/m].strip.squeeze(" ")
  end

  def form
    @content[/(SAS|SARL|SA|SCI|EURL|SASU|S\.A\.S|S\.A\.R\.L|S\.A|S\.C\.I|E\.U\.R\.L|S\.A\.S\.U)/]
  end

  def name_article
    company_designation = ''
    @article_objects.each do |article|
      company_designation = article.full_article if article.full_article[/(dénomination sociale|DENOMINATION)/]
    end
    return company_designation
  end

end

# doc.articles.map do |article|
#   Article.new(article)
# end

# articles_hash = {}
# Article.all.each do |article|
#   articles_hash[article.title] = article.content
# end



# company_name_article = []
# Article.all.each do |article|
#   company_name_article << article.full_article if article.full_article[/(dénomination sociale|DENOMINATION)/]
# end

# company_head_office = []
# Article.all.each do |article|
#   company_head_office << article.full_article if article.full_article[/siège social est/]
# end


# company_share_capital = []
# Article.all.each do |article|
#   company_share_capital << article.full_article if article.full_article[/(capital social|capital initial)/] && article.full_article[/libéré/] && !article.full_article[/apport/]
# end

# company_purpose = []
# Article.all.each do |article|
#   company_purpose << article.full_article if article.full_article =~ /objet social est/ || article.full_article =~ /a pour objet/
# end

# company_directors = []
# Article.all.each do |article|
#   if article.title =~ /président directeur général/i
#     company_directors << "Président Directeur Général"
#   elsif article.title =~ /président/i
#     company_directors << "Président"
#   elsif article.title =~ /gérant/i
#     company_directors << "Gérant"
#   elsif article.title =~ /directoire/i
#     company_directors << "Directoire"
#   end
#   company_directors << "Directeur Général Délégué" if article.title =~ /directeur général délégué/i
#   company_directors << "Directeur Général" if article.title =~ /directeur général/i
# end

# # powers_article = []

# # company_directors.each do |director|
# #   articles_content.flatten.each do |article|
# #     powers_article << article if article =~ /(#{director} ne peut|#{director} ne pourra|#{director} ne pourront|autorisation préalable|sans l'accord)/i
# #   end
# # end

# power_chunk = {}
# company_directors.each do |director|
#   Article.all.each do |article|
#   if article.content =~ /(?<=\.)([^\.]*(?:#{director} ne peut|#{director} ne pourra|#{director} ne pourront|autorisation préalable|sans l'accord)[^\.]*)(?=\.)/i
#     power_chunk[article.title] = article.content[/(?<=\.)([^\.]*(?:#{director} ne peut|#{director} ne pourra|#{director} ne pourront|autorisation préalable|sans l'accord)[^\.]*)(?=\.)/i]
#   end
#   end
# end

# company_corporate_bodies = []
# Article.all.each do |article|
#   if article.title =~ /comité/i
#     company_corporate_bodies << article.title[/(ARTICLE\s+[\d]+.)(.+)/, 2]
#     break
#   end
#   if article.title =~ /commission/i
#     company_corporate_bodies << article.title[/(ARTICLE\s+[\d]+.)(.+)/, 2]
#     break
#   end
#   if article.title =~ /direction/i
#     company_corporate_bodies << article.title[/(ARTICLE\s+[\d]+.)(.+)/, 2]
#     break
#   end
# end

# company_lenght = []

# Article.all.each do |article|
#   company_lenght << article.full_article if article.full_article =~ /(durée|duree)/i && article.full_article =~ /(est fixée)/i && article.full_article =~ /(immatriculation)/i
# end

# company_social_decisions = []

# Article.all.each do |article|
#   company_social_decisions << article.full_article if article.title =~ /(assemblée générale|décisions collectives|décisions des associés|décisions d'associés)/i
# end

# print company_social_decisions