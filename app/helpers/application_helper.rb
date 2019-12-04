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
    [:no_help, :plain_text, :html_text, :web_url].map.with_index { |x, i| [x.to_s.titleize, i] }
  end

  def metadata_types
    { '0' => 'Dublin Core' }
  end 

  def idno_numbering_types
    ['user', 'system'].map { |k, v| [k.humanize.titleize, k] }
  end

  def choice_types
    ['manual', 'link_to_form'].map {|k, v| [k.humanize.titleize, k]}
  end
end
