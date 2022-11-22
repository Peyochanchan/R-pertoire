require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  login_user
  let(:song) { FactoryBot.create(:song) }
  let(:user_id) { subject.current_user.id }
  let(:private_attributes) {
    {
      title: 'Test title',
      lyrics: 'Je revois \r la ville en fête \r et <br/> en délire',
      composer: 'Jacques',
      public: false,
      user_id: user_id
    }
  }

  context 'GET #show' do
    before(:example) do
      @song = FactoryBot.create(:song)
      @new_song = Song.new(private_attributes)
    end

    it 'should have a current_user' do
      expect(subject.current_user).to_not eq(nil)
    end

    it 'returns a success response' do
      get :show, params: { id: @song.id }, session: { user_id: user_id }
      expect(response).to be_successful
    end
  end

  context 'GET #actions' do
    let(:new_song) { Song.new }

    it '#new returns a success response' do
      get :new, params: { song: new_song }
      expect(response).to have_http_status(200)
    end

    it 'assigns a new song' do
      get :new
      expect(assigns[:song]).to be_a(Song)
    end

    it 'can receive a Title' do
      allow(new_song).to receive(:title).and_return('Tweedledee')
      expect(new_song.title).to eq 'Tweedledee'
    end

    # it '#create returns a success html response' do
    #   post :create, params: { song: private_attributes, user_id: user_id }, format: :html
    #   # expect(response).to be_truthy
    #   expect(response.content_type).to eq "text/html; charset=utf-8"
    # end
  end
end
