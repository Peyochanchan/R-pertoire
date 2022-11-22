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
RSpec.describe Song, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:song) { FactoryBot.create(:song) }

  let(:attributes) {
                     {
                        title: 'L\'aventura',
                        lyrics:'la banane',
                        public: true,
                        lyrics_ar: 'putaing con',
                        lyrics_en: 'Watchmilla',
                        lyrics_es: 'Ben ouaé',
                        lyrics_fr: 'Rholala',
                        lyrics_nb: 'Pfiou loulou',
                        composer: 'gerard',
                        title_ar: 'example',
                        title_en: 'example',
                        title_es: 'example',
                        title_fr: 'example',
                        title_nb: 'example',
                        user: user
                     }
                   }
  let(:empty) {
                 {
                    title: nil,
                    lyrics: nil,
                    public: true,
                    lyrics_ar: nil,
                    lyrics_en: nil,
                    lyrics_es: nil,
                    lyrics_fr: nil,
                    lyrics_nb: nil,
                    title_ar: nil,
                    title_en: nil,
                    title_es: nil,
                    title_fr: nil,
                    title_nb: nil,
                    composer: nil,
                    user: user
                 }
               }

  it { is_expected.to be_a Song }

  it 'should check if the song is created' do
    expect(user).not_to be_nil
    expect(song).to be_valid
    expect(Song.count).to eq(1)
  end

  it 'is not possible without a user' do
    song.user = nil
    expect(song).not_to be_valid
  end

  it 'verify double instance' do
    song = instance_double('Song')
    allow(song).to receive(:user).and_return(nil)
    presenter = described_class.new(attributes)
    expect(presenter.title).to include('aventura')
  end
  it 'creates a song public' do
    song = create(:song, public: true)
    expect(song).to be_public
  end

  it 'creates a private song' do
    song = create(:song, public: false)
    expect(song).not_to be_public
  end
end
