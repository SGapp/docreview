class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      ExtractionWorker.perform_async(@document.id)
      redirect_to successupload_path
    else
      render action: 'new'
    end
  end

private
  def document_params
    params.require(:document).permit(:document_type, :attachment)
  end

end
