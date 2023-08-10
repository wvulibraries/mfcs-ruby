# Namespace for classes and modules that handle serving HTML from Field Data Hashes.
# @since 0.0.0
class FieldBuilder::Variable
  # Class used for holding methods that parse variables in form builder documents.
  # @author(s) David J. Davis, Tracy A. McCormick
  # @abstract
  # @since 0.0.0

  # Static Date/Time
  # %date%
  # The current date as MM/DD/YYYY. (Example: 2019-10-17)
  # %time%
  # The current time as HH:MM:SS. (Example: 09:12:12)
  # %time12%
  # The current 12-hr time. (Example: 9:12:12 AM)
  # %time24%
  # The current 24-hr time. (Example: 09:12:12)
  # %timestamp%
  # The current UNIX system timestamp. (Example: 1571317932)

  # Substitues variables for the strings.
  #
  # @example
  #   result = FieldBuilder::Variable.sub_vars(test_str, user)
  #   puts result.inspect # returns modified string
  #
  # @author(s) David J. Davis, Tracy A. McCormick
  # @return [String]
  def self.sub_vars(str, current_user)
    vars = {
      '%date%' => Time.zone.now.strftime('%m/%d/%Y'),
      '%timestamp%' => Time.now.to_i,
      '%time%' => Time.zone.now.strftime('%H:%M:%S'),
      '%time12%' => Time.zone.now.strftime('%I:%M:%S %p'),
      '%time24%' => Time.zone.now.strftime('%H:%M:%S'),
      '%lastname%' => current_user.last_name,
      '%firstname%' => current_user.first_name,
      '%username%' => current_user.username
    }

    str.gsub!(/%([A-Za-z\d]+?)%/, vars) if vars?(str)
    str = parse_custom_date(str) if custom_date?(str)
    str
  end

  # Determines if there are vars that need to be replaced.
  #
  # @example
  #   FieldBuilder::Variable.vars?(test_string) # True || # False
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.vars?(str)
    regex = /%([A-Za-z\d]+?)%/
    vars = str.scan(regex).reject(&:blank?)
    !vars.empty?
  end

  # Determines if there is a custom date that needs to be processed.
  #
  # @example
  #   FieldBuilder::Variable.custom_date?(str) # True || # False
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.custom_date?(str)
    regex = /%date\(.*?\)%/
    custom_dates = str.scan(regex).reject(&:blank?)
    !custom_dates.empty?
  end

  # Substitues variables for custom date fields.
  #
  # @example
  #   result = FieldBuilder::Variable.parse_custom_date(test_str)
  #   puts result.inspect # returns modified string
  #
  # @author(s) David J. Davis, Tracy A. McCormick
  # @return [String]
  def self.parse_custom_date(str)
    regex = /%date\(.*?\)%/
    format_regex = /%date\(['|"](.+?)['|"]\)%/
    str.gsub(regex) do |date_str|
      date_format = date_str.scan(format_regex)
      return '' if date_format.empty? || date_format.nil?

      return Time.zone.now.strftime(date_format.first.first)
    end
  end
end
