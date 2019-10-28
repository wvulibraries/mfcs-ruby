# adds a helpable module to reuse in all fields
module Helpable
  extend ActiveSupport::Concern
  included do
    enum help_type: { no_help: 0, plain_text: 1, html_text: 2, web_url: 3 }
  end
end
