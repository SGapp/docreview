class Contract
  attr_reader :reader

  def initialize(text_path)
    # begin
      @reader = PdfDoc.new(text_path)
      raise if @reader.content.empty?
    # rescue
    #   @reader = Abby.new(text_path)
    # end
  end

  def content
    @content ||= @reader.content
  end

  def articles
    content.scan(/ARTICLE.*?(?=ARTICLE|\nTITRE|TITRE|\z)/m).map do |article|
      Article.new(article)
    end
  end


end