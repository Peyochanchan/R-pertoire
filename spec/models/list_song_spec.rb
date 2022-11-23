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
RSpec.describe ListSong, type: :model do
  let(:list)     { FactoryBot.create(:list) }
  let(:song) { FactoryBot.create(:song) }
  subject(:list_song) { FactoryBot.create(:list_song, :private) }
  let(:attributes) { { position: 1, tonality: 'Bonjour', song_id: song.id, list_id: list.id } }
  let(:list_song_one) { FactoryBot.build(:list_song) }

  it { is_expected.to be_a ListSong }
  it { is_expected.to be_persisted }

  it 'gives a musical tonality included in TONALITIES List' do
    puts { list_song_one }
    presenter = described_class.new(attributes)
    expect(presenter).not_to be_valid
  end
end
