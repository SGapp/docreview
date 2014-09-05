class Contract
  attr_reader :reader

  def initialize(text_path)
    begin
      @reader = PdfDoc.new(text_path)
      puts '*'*50
      puts content.empty?
      puts '*'*50
      raise if content.empty?
      puts '*'*50
      puts "Pdf"
      puts '*'*50
    rescue
      @reader = Abby.new(text_path)
      puts '*'*50
      puts "Abby"
      puts '*'*50
    end
  end

  def content
    result ||= @reader.content
  end

  def articles
    content.scan(/ARTICLE.*?(?=ARTICLE|\nTITRE|TITRE|\z)/m).map do |article|
      Article.new(article)
    end
  end


end