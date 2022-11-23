require 'rails_helper'

RSpec.describe ListSongsController, type: :controller do
  let(:list_song) { FactoryBot.create(:list_song) }
  let(:list_song_new) { FactoryBot.build(:list_song) }

  let(:list) { FactoryBot.create(:list) }
  let(:song) { FactoryBot.create(:song) }
  let(:private_attributes) { { position: 18, tonality: 'Dm', list_id: list.id, song_id: song.id } }

  subject { described_class.new(list, song) }

  it 'can receive a Position' do
    allow(@new_list_song).to receive(:position).and_return(4)
    expect(@new_list_song.position).to eq(4)
  end

  it 'can receive a Song Id' do
    allow(@new_list_song).to receive(:song_id).and_return(4)
    expect(@new_list_song.song_id).to eq(4)
  end

  it 'can #update its Position' do
    allow(list_song).to receive(:position).and_return(4)
    expect(list_song.position).to eq(4)
  end

  it 'can not receive a new song_id' do
    allow(list_song).to receive(:song_id).and_return(4)
    expect(list_song.song_id).to eq(4)
  end

  it 'can not receive a new list_id' do
    allow(list_song).to receive(:list_id).and_return(8)
    expect(list_song.list_id).to eq(8)
  end
end
