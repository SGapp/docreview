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
    if @extractor.powers_limitations(@extractor.directors) == nil
      doc.replace("LIMITATIONS", "Les statuts ne comportent pas de limitations de pouvoirs", true)
    else
      doc.replace("LIMITATIONS", @extractor.powers_limitations(@extractor.directors).join("\n"), true)
    end
    doc.replace("ORGANES", @extractor.corporate_bodies.join(", "), true)
    doc.replace("DECISIONS", @extractor.social_decisions.join("\n"), true)
    doc.replace("PREEMPTION", @extractor.preemption, true)
    binding.pry
    doc.replace("AGREMENT", @extractor.approval, true)
    # if @extractor.preemption == nil
    #   doc.replace("PREEMPTION", "Les statuts ne comportent pas de clause de préemption", true)
    # else
    #   doc.replace("PREEMPTION", @extractor.preemption, true)
    # end
    # if @extractor.approval == nil
    #   doc.replace("AGREMENT", "Les statuts ne comportent pas de clause d'agrément", true)
    # else
    #   doc.replace("AGREMENT", @extractor.approval, true)
    # end
    # Write the document back to a temporary file
    tmp_file = Tempfile.new(SecureRandom.hex(5), "#{Rails.root}/tmp")
    @tmp_file_path = tmp_file.path
    doc.commit(@tmp_file_path)
    @tmp_file_path

    # Respond to the request by sending the temp file
    # send_file tmp_file.path, filename: "company_report.docx", disposition: 'attachment'
  end
end