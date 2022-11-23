# == Schema Information
#
# Table name: list_songs
#
#  id         :bigint           not null, primary key
#  position   :integer
#  tonality   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  list_id    :bigint           not null
#  song_id    :bigint           not null
#
# Indexes
#
#  index_list_songs_on_list_id  (list_id)
#  index_list_songs_on_song_id  (song_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_id => lists.id)
#  fk_rails_...  (song_id => songs.id)
#
class ListSong < ApplicationRecord
  belongs_to :list
  belongs_to :song

  TONALITIES = %w[Am A A#m A# Bbm Bb Bm B Cm C C#m C# Dbm Db Dm D D#m D# Ebm Eb Em E Fm F F#m F# Gbm Gb Gm G G#m G# Abm Ab].freeze

  belongs_to :list
  belongs_to :song
  # validates :song, uniqueness: { scope: :list }
  validates :list_id, presence: true
  validates :song_id, presence: true
  validates :tonality, inclusion: { in: TONALITIES }, allow_nil: true

  accepts_nested_attributes_for :song
end
