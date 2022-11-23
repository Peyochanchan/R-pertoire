# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  nickname               :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
RSpec.describe 'User', type: :model do
  context 'user creation' do
    let(:user) { FactoryBot.create(:user) }
    it 'should check if the user is created' do
      expect(user).not_to be_nil
      expect(User.count).to eq(1)
    end

    it 'should check if the admin user is created' do
      user.admin = true
      user.save
      expect(user).not_to be_nil
      expect(user.admin).to be_truthy
    end
  end
end
