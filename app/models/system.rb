class System < ApplicationRecord
  def self.check(name)
    !!System.where(name: name).pluck(:value).first
  end
end
