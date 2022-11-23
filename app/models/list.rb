# == Schema Information
#
# Table name: lists
#
#  id             :bigint           not null, primary key
#  description    :text
#  description_ar :text
#  description_en :text
#  description_es :text
#  description_fr :text
#  description_nb :text
#  name           :string
#  name_ar        :string
#  name_en        :string
#  name_es        :string
#  name_fr        :string
#  name_nb        :string
#  public         :boolean
#  qr_code        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class List < ApplicationRecord
  has_many :list_songs, -> { order(position: :asc) }, dependent: :destroy
  has_many :songs, through: :list_songs
  belongs_to :user
  has_one_attached :photo
  validates :name, presence: true
  validates :description, presence: true
  accepts_nested_attributes_for :list_songs, allow_destroy: true
  accepts_nested_attributes_for :songs, allow_destroy: true
  accepts_nested_attributes_for :user
end
