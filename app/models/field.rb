# Generic Field Class, building block for all fields that
# contains the following information.
#
# ==== Strings
#
# * name
# * label
# * type
# * value
# * css_id
# * css_class
# * local_styles
# * help_type
# * help_info
# * metadata_schema
#
# ==== Booleans
#
# * required
# * no_duplicates
# * read_only
# * disabled
# * disabled_on_insert
# * public_release
# * oai_release
# * sortable
# * searchable
# * display_in_list
# * hidden
#
class Field < ApplicationRecord
  # validations
  validates_presence_of :name, :label, :type
end
