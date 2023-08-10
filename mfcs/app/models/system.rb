# == Schema Information
#
# Table name: systems
#
#  id         :bigint           not null, primary key
#  name       :string
#  value      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class System < ApplicationRecord
  def self.check(name)
    !!System.where(name: name).pick(:value)
  end
end
