

# For models that need readonly status
module Readonly
  extend ActiveSupport::Concern

  # System check for readonly values.
  # This will make any model readonly when the system
  # check is true.
  # Active Record Model Only - this is an override.
  # @author David J. Davis
  # @return boolean
  def readonly?
    System.check('readonly')
  end
end
