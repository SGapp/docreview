class Document < ActiveRecord::Base
  extend Enumerize
  validates :document_type, presence: true
  validates :attachment, presence: true
  enumerize :document_type, in: [:bylaws]
  mount_uploader :attachment, AttachmentUploader

  include AASM

  aasm column: :state do
    state :pending, :initial => true
    state :processed

    event :processed do
      transitions :from => :pending, :to => :processed
    end

  end
end
