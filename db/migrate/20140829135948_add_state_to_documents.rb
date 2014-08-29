class AddStateToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :state, :string
  end

  def self.down
    remove_column :documents, :state
  end
end
