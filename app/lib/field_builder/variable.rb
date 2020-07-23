module FieldBuilder
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

  class Variable
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
      return str
    end

    def self.vars?(str)
      regex = /%([A-Za-z\d]+?)%/
      vars = str.scan(regex).reject(&:blank?)
      !vars.empty?
    end

    def self.custom_date?(str)
      regex = /%date\(.*?\)%/
      custom_dates = str.scan(regex).reject(&:blank?)
      !custom_dates.empty?
    end

    def self.parse_custom_date(str)
      regex = /%date\(.*?\)%/
      format_regex = /%date\(['|"](.+?)['|"]\)%/
      str.gsub(regex) do |date_str|
        date_format = date_str.scan(format_regex)
        if date_format.empty? || date_format.nil?
          return ''
        else
          return Time.zone.now.strftime(date_format.first.first)
        end
      end
    end
  end
end
