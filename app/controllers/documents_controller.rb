class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to successupload_path
    else
      hlacblj
      render action: 'new'
    end
  end

private
  def document_params
    params.require(:document).permit(:document_type, :attachment)
  end

end
