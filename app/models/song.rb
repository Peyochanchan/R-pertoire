# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  composer   :string
#  lyrics     :text
#  lyrics_ar  :text
#  lyrics_en  :text
#  lyrics_es  :text
#  lyrics_fr  :text
#  lyrics_nb  :text
#  public     :boolean
#  title      :string
#  title_ar   :string
#  title_en   :string
#  title_es   :string
#  title_fr   :string
#  title_nb   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_songs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Song < ApplicationRecord
  has_many :list_songs, dependent: :destroy
  has_many :lists, through: :list_songs
  belongs_to :user

  accepts_nested_attributes_for :lists, :list_songs
end
