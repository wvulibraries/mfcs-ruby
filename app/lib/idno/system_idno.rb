# Extendible Class for Setting IDNO
# @author David J. Davis
# @since 0.0.0
class Idno::SystemIdno 
  # Sets the Pattern and form ID so the IDNO can be generated properly.
  # @abstract
  # @param form_id [Integer] - ID for form.
  # @param pattern [String] - Pattern from form fields for idno.
  # @author David J. Davis
  def initialize(form_id, field_info)
    @form_id = form_id
    @pattern = field_info['idno_format']
    @start_count = field_info['start_increment'].to_i
  end 

  # Creates a padding string of the provided integer based on database count.
  # @param count [Integer] - count of idnos in form
  # @param pattern [String] - Pattern created in the form builder.
  # @return [String] 
  # @author David J. Davis
  def create_idno(count, padding)
    count.to_s.rjust(padding, '0')
  end 

  # Uses the pattern to swap the variable data for the real data.
  # @return [String] 
  # @author David J. Davis
  def formatted_idno
    first_variable = @pattern.index('#')
    last_variable = @pattern.rindex('#') 
    idno = create_idno(item_count, padding_size) 
    temp_string = @pattern
    temp_string[first_variable..last_variable] = idno
    temp_string
  end 

  # Counts the items in the database that use that form ID. 
  # The idea is that counting the items gives us a realistic way create 
  # non-colliding IDNO numbers.
  # @return [Integer] 
  # @author David J. Davis
  def item_count
    record_count = Item.where(form_id: @form_id).count
    if record_count == 0 && @start_count == 0  
      return 1 
    else
      record_count + @start_count
    end 
  end 

  # Uses the pattern to determine padding by grabbing a substring
  # of the variable data and counting how long it is.
  # @return [Integer] 
  # @author David J. Davis
  def padding_size 
    first_variable = @pattern.index('#')
    last_variable = @pattern.rindex('#') 
    substring = @pattern[first_variable..last_variable]
    substring.length
  end 
end 