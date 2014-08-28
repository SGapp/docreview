class Document < ActiveRecord::Base
  extend Enumerize
  validates :document_type, presence: true
  validates :attachment, presence: true
  enumerize :document_type, in: [:bylaws]
  mount_uploader :attachment, AttachmentUploader
end
