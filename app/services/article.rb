class Article
  attr_reader :full_article

  def initialize(full_article)
    @full_article = full_article.strip.squeeze(" \n\t\r")
  end

  def title
    @title ||= full_article[/ARTICLE\s*[\d]*\s*[\.|-]*[^\n]+/]
  end

  def content
    @content ||= full_article[/#{Regexp.escape title}(.*)/m, 1]
  end

  # def self.all
  #   ObjectSpace.each_object(self).to_a.reverse
  # end
end