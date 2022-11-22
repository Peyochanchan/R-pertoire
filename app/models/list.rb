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
class List < ApplicationRecord
  belongs_to :user
end
