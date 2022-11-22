require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  login_user
  let(:list) { double(List) }
  let(:private_attributes) { { name: 'Test Name', public: false, description: 'description', user_id: user_id } }
  let(:user_id) { subject.current_user.id }

  # context 'INDEX' do
  #   it 'allows unauthenticated access' do
  #     puts subject.current_user.admin?
  #     sign_in nil
  #     get :index
  #     expect(response).to be_successful
  #   end

    it 'allows authenticated access' do
      get :index
      expect(response).to be_successful
    end
  # end

  context 'GET #show' do
    let(:public_attributes) { { name: 'Test Public', description: 'description', public: true, user_id: user_id } }
    let(:invalid_attributes) { { name: 4, public: false, user_id: user_id } }

    before(:example) do
      @user = FactoryBot.create(:user)
      @list = List.create(private_attributes)
      @new_list = List.new
    end

    it 'should have a current_user' do
      expect(subject.current_user).to_not eq(nil)
    end

    it 'returns a success response' do
      get :show, params: { id: @list.id }, session: { user_id: user_id }
      expect(response).to be_successful
    end
  end

  describe '#GET actions' do
    login_user
    let(:user_id) { subject.current_user.id }
    let(:private_attributes) { { name: 'Test Name', description: 'description', public: false, user_id: user_id } }

    it '#new returns a success response' do
      get :new, params: { song: @new_list }
      expect(response).to have_http_status(200)
    end

    it 'assigns a #new list' do
      get :new
      expect(assigns[:list]).to be_a(List)
    end

    it 'can receive a Name' do
      allow(@new_list).to receive(:name).and_return('Tweedledoo')
      expect(@new_list.name).to eq 'Tweedledoo'
    end
  end

  describe '#POST actions' do
    context '#create works when user is admin' do
      logout_user
      login_admin

      it '#create return a success json response' do
        puts "      user is admin : #{subject.current_user.admin?}"
        post :create, params: { list: private_attributes }, format: :json
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end
    end
  end
end
