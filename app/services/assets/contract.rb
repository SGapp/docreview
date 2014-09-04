class Contract
  attr_reader :reader, :content

  def initialize(text_path)
    begin
      @reader = PDF::Reader.new(text_path)
      if content.empty?
        @reader = Abby::Doc.new(text_path)
      end
    rescue
      @reader = Abby::Doc.new(text_path)
    end
  end

  def content
    case @reader.class.name
    when "PDF::Reader"
     @content ||= doc_pages(@reader).join("\n")
                                  .gsub(/[\n]+/, "\n")
                                  .gsub(/(?<=[^\.:!?-])([\n]+)(?=([^A-Z\d]))/m, " ")
    when "Abby::Doc"
      @content = @reader.recognized_text
    end
  end

  def articles
    content.scan(/ARTICLE.*?(?=ARTICLE|\nTITRE|TITRE|\z)/m).map do |article|
      Article.new(article)
    end
  end

  private

  def doc_pages(reader)
    reader.pages.map(&:text).map do |page|
      page.gsub(/\s+\d+\z/, '')
    end
  end
end