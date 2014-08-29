class AddTemplatePathToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :template_path, :string
  end
end
