module FieldBuilder
  # --------------------------------------------------------------------------
# -- THE SPECS
# --------------------------------------------------------------------------
​
# Available variables for default value
​
#
​
# %date%
# The current date as MM/DD/YYYY. (Example: 2020-07-09)
​
# %time%
# The current time as HH:MM:SS. (Example: 12:18:03)
​
# %time12%
# The current 12-hr time. (Example: 12:18:03 PM)
​
# %time24%
# The current 24-hr time. (Example: 12:18:03)
​
# %timestamp%
# The current UNIX system timestamp. (Example: 1594311483)
# Custom Date/Time
​
# %date(FORMAT)%
# You can specify a custom format when creating dates and times where FORMAT is a PHP date() format string.
# Example: %date(l, m j Y)% becomes Thursday, July 9 2020

  class Variable
    # User

    # %userid%
    # The user id for the currently logged in user. (Example: 28)
    ​
    # %username%
    # The username for the currently logged in user. (Example: djdavis)
    ​
    # %firstname%
    # The first name for the currently logged in user. (Example: David )
    ​
    # %lastname%
    # The last name for the currently logged in user. (Example: Davis)
		def self.user_info(current_user, key_info)
    end 
    
    # DATE

    def self.parse_date_time(variable_string)
      temp_str = variable_string.to_s.downcase
      if temp_str == '%date%'
        Time.now.strftime('%Y/%m/%d')
      elsif temp_str == '%time%' || temp_str == '%time24%'
        Time.now.strftime('%H:%M:%s')
      elsif temp_str == '%time12%'
        Time.now.strftime("%I:%M %p")
      elsif temp_str == '%timestamp%'
        Time.now.to_i
      else 
        self.get_date_format(variable_string)
      end
    end 

        
    def self.get_date_format(str)
      regex = %r[(?<=\().+?(?=\))]
      str.scan(regex).first
    end 
	end
end 