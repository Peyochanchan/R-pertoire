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
FactoryBot.define do
  factory :list_song do
    position { rand(0..100) }
    tonality { 'Dm' }
    association :list
    association :song

    trait :public do
      association :song, public: true
      association :list, public: true
    end
    trait :private do
      association :song, public: false
      association :list, public: false
    end
  end
end
