class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  scope :feed_by_user, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.models.micropost.content_length_max}
  validate  :picture_size

  private

  def picture_size
    return unless picture.size > Settings.models.micropost.pic_size.megabytes
    errors.add(:picture, t("models.micropost.error_size"))
  end
end
