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
FactoryBot.define do
  factory :song do
    title { 'La Foule' }
    lyrics { 'Je revois \r la ville en fête \r et <br/> en délire' }
    public { true }
    composer { 'Edith Piaf' }
    lyrics_ar { 'putaing con' }
    lyrics_en { 'Watchmilla' }
    lyrics_es { 'Ben ouaé' }
    lyrics_fr { 'Rholala' }
    lyrics_nb { 'Pfiou loulou' }

    title_ar { 'utain' }
    title_en { 'atchm' }
    title_es { 'en ou' }
    title_fr { 'olala' }
    title_nb { 'ou lo' }

    user
  end
end
