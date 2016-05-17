class Attachment < ActiveRecord::Base
  belongs_to :question
  belongs_to :answer

  mount_uploader :file, FileUploader
end
