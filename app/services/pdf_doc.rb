class PdfDoc

  def initialize(text_path)
    @reader = PDF::Reader.new(text_path)
  end

  def content
    @content ||= doc_pages(@reader).join("\n")
                                   .gsub(/[\n]+/, "\n")
                                   .gsub(/(?<=[^\.:!?-])([\n]+)(?=([^A-Z\d]))/m, " ")
  end

  private

  def doc_pages(reader)
    @reader.pages.map(&:text).map do |page|
      page.gsub(/\s+\d+\z/, '')
    end
  end
end