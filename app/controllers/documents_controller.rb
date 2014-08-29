class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      HardWorker.perform_async(@document.id)
      redirect_to document_path(@document)
    else
      render action: 'new'
    end
  end

  def show
    @document = Document.find(params[:id])
    if @document.state == "processed"
      send_file @document.template_path, filename: "company_report.docx", disposition: 'attachment'
    end
  end

private
  def document_params
    params.require(:document).permit(:document_type, :attachment)
  end

end
