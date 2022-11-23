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
FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:first_name) { |n| "User#{n}" }
    sequence(:last_name) { |n| "#{n}name" }
    sequence(:nickname) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@maison.com" }
    admin { false }
    password { '123456' }
    created_at { Time.now }
    updated_at { Time.now }

    trait :admin do
      admin { true }
    end
  end
end
