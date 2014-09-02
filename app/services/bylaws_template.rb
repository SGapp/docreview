class BylawsTemplate
  attr_reader :extractor, :tmp_file_path

  def initialize(extractor)
    @extractor = extractor
  end

  def company_report
    # Initialize DocxReplace with your template
    doc = DocxReplace::Doc.new("#{Rails.root}/lib/docx_templates/fiche_societe.docx", "#{Rails.root}/tmp")

    # Replace some variables. $var$ convention is used here, but not required.
    doc.replace("DENOMINATION_DE_LA_SOCIETE", @extractor.name, true)
    doc.replace("FORME_SOCIALE", @extractor.form, true)
    doc.replace("DENOMINATION_SOCIALE", @extractor.designation, true)
    doc.replace("DUREE_SOCIETE", @extractor.duration, true)
    doc.replace("ADRESSE_SIEGE", @extractor.head_office, true)
    doc.replace("OBJET_SOCIAL", @extractor.purpose, true)
    doc.replace("CAPITAL_SOCIAL", @extractor.share_capital, true)
    doc.replace("REPARTITION", @extractor.contribution, true)
    doc.replace("DIRIGEANTS", @extractor.directors.join(", "), true)
    doc.replace("LIMITATIONS", @extractor.powers_limitations(@extractor.directors), true)
    doc.replace("ORGANES", @extractor.corporate_bodies, true)
    doc.replace("DECISIONS", @extractor.social_decisions, true)
    doc.replace("PREEMPTION", @extractor.preemption, true)
    doc.replace("AGREMENT", @extractor.approval, true)
    doc.replace("INALIENABILITE", @extractor.inalienability, true)
    doc.replace("CONTROLE", @extractor.change_of_control, true)
    doc.replace("CONJOINTE", @extractor.tag_along, true)
    doc.replace("FORCEE", @extractor.drag_along, true)
    doc.replace("EXCLUSION", @extractor.exclusion, true)
    doc.replace("EXERCICE", @extractor.financial_year, true)



    # Write the document back to a temporary file
    tmp_file = Tempfile.new(SecureRandom.hex(5), "#{Rails.root}/tmp")
    @tmp_file_path = tmp_file.path
    doc.commit(@tmp_file_path)
    @tmp_file_path

    # Respond to the request by sending the temp file
    # send_file tmp_file.path, filename: "company_report.docx", disposition: 'attachment'
  end
end