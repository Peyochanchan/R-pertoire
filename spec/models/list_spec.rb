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
RSpec.describe List, type: :model do
  context 'List creation' do
    subject(:list) { FactoryBot.create(:list) }
    it { is_expected.to be_a List }
    it { is_expected.to be_persisted }

    let(:user) { FactoryBot.create(:user) }
    let(:user_one) { FactoryBot.create(:user, email: 'gerard@maison.com') }
    let(:list) { FactoryBot.create(:list, name: 'Catcher in the Rye', user: user) }
    let(:attributes) { { name: 'Catcher in the Rye', public: true, user: user } }
    let(:valid_params) { { email: 'gerard@maison.com' } }

    it 'should check if the list is created' do
      expect(user).not_to be_nil
      expect(list).to be_valid
      expect(List.count).to eq(1)
    end

    it 'is not possible without a user' do
      list.user = nil
      expect(list).not_to be_valid
    end

    it 'verifying double instance' do
      list = instance_double('List')
      allow(list).to receive(:user).and_return(nil)

      presenter = described_class.new(attributes)
      expect(presenter.name).to include('Catcher in the Rye')
    end
    it 'creates a list public' do
      list = create(:list, public: true)
      expect(list).to be_public
    end

    it 'creates a private list' do
      list = create(:list, public: false)
      expect(list).not_to be_public
    end
  end
end
