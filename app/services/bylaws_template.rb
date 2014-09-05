class BylawsTemplate
  attr_reader :extractor, :tmp_file_path

  def initialize(extractor, mapping)
    @extractor = extractor
    @mapping = mapping  # Hash
  end

  def company_report
    # Initialize DocxReplace with your template
    @doc = DocxReplace::Replace.new("#{Rails.root}/lib/docx_templates/fiche_societe.docx", "#{Rails.root}/tmp")
    puts @mapping
    # Replace some variables. $var$ convention is used here, but not required.
    @mapping.each do |key, value|
      @doc.replace(key, @extractor.send(value.to_sym), true)
    end
  end

  def tmp_file_path
    # Write the document back to a temporary file
    tmp_file = Tempfile.new(SecureRandom.hex(5), "#{Rails.root}/tmp")
    @tmp_file_path = tmp_file.path
    @doc.commit(@tmp_file_path)
    @tmp_file_path
    # Respond to the request by sending the temp file
    # send_file tmp_file.path, filename: "company_report.docx", disposition: 'attachment'
  end


end