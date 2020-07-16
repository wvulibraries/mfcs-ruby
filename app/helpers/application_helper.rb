module ApplicationHelper
  # valdiation options
  def form_validation_options
    {
      regexp: 'Regular Expression',
      phone_number: 'Phone Number',
      ip_addr: 'IP Address',
      ip_range: 'IP Range',
      optional_url: 'Optional Url',
      url: 'Url',
      email_addr: 'Email Address',
      internal_email_addr: 'Internal Email',
      integer: 'Integer',
      integer_spaces: 'Integer Spaces',
      alpha_numeric: 'Alpha Numeric',
      alpha_numeric_no_space: 'Alpha Numeric (No Spaces)',
      alpha: 'Alphabetical Only',
      alpha_no_spaces: 'Alphabetical Only (No Spaces)',
      no_spaces: 'No Spaces',
      no_special_chars: 'No Special Characters',
      date: 'Date'
    }.map(&:reverse)
  end

  def help_types
    [:no_help, :plain_text, :html_text, :web_url].map { |k, v| [k.to_s.humanize.titleize, k] }
  end

  def metadata_types
    ['dublin_core'].map { |k, v| [k.humanize.titleize, k] }
  end 

  def idno_numbering_types
    ['user', 'system'].map { |k, v| [k.humanize.titleize, k] }
  end

  def choice_types
    ['manual', 'link_to_form'].map {|k, v| [k.humanize.titleize, k] }
  end

  def text_formats
    ['word', 'characters'].map {|k, v| [k.humanize.titleize, k] }
  end

  # dynamically add fieldsets
  # setup from rails casts
  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, form: builder)
    end
    link_to(name, '#', class: 'add-fields', data: { id: id, fields: fields.gsub("\n", "") })
  end
end
