class Conversion::Base
  def perform
    method_error(__method__)
  end

  def save_file
    method_error(__method__)
  end

  def save_media
    method_error(__method__)
  end

  private

  def method_error(method)
    raise NoMethodError, "#{self.class} has not implemented the #{method} method."
  end
end
