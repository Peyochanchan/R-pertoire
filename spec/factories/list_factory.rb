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
FactoryBot.define do
  factory :list do
    sequence(:name) { |n| "This List #{n}" }
    name_ar        { "name_fr" }
    name_en        { "name_en" }
    name_es        { "name_es" }
    name_fr        { "name_ar" }
    name_nb        { "name_nb" }
    sequence(:description) { |n| "Incroyable description pouur la #{n}ième fois"}
    description_ar { "description_en" }
    description_en { "description_es" }
    description_es { "description_fr" }
    description_fr { "description_ar" }
    description_nb { "description_nb" }

    public { false }
    user
  end
end
