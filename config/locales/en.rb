# Files in the config/locales directory are used for internationalization
# and are automatically loaded by Rails. If you want to use locales other
# than English, add the necessary files in this directory.
#
# To use the locales, use `I18n.t`:
#
#     I18n.t 'hello'
#
# In views, this is aliased to just `t`:
#
#     <%= t('hello') %>
#
# To use a different locale, set it with `I18n.locale`:
#
#     I18n.locale = :es
#
# This would use the information in config/locales/es.yml.
#
# The following keys must be escaped otherwise they will not be retrieved by
# the default I18n backend:
#
# true, false, on, off, yes, no
#
# Instead, surround them with single quotes.
#
# en:
#   'true': 'foo'
#
# To learn more, please read the Rails Internationalization guide
# available at http://guides.rubyonrails.org/i18n.html.

{ en: 
  { 
    hello: "Hello world",
    login_failure: 'The login has failed because the user does not exist, or you do not have permission to use this application.  If you believe that this is an error, please contact the system administrator.',
    form_builder: { 
      image_file_types: [['jpg', 'JPG'], ['png', 'PNG'], ['gif', 'GIF'], ['bmp', 'BMP'], ['webp', 'WEBP']],
      audio_bitrates: [['700kbs (Low Quality)', 700], ['1200kbs (Fast Streaming)', 1200], ['2400kbs (YouTube Quality)', 2400], ['5000kbs (HD Quality)', 5000], ['12000kbs (HDTV Quality)', 12000]],
      audio_formats: [['MP3 (Recommended)', 'mp3'], ['OGG', 'ogg'], ['WAV', 'wav']],
      video_bitrates: [['32kbs (Speeches)', 32], ['64kbs (Fast Streaming)', 64], ['128kbs (Recommended)', 128], ['192kbs (High Quality)', 192], ['256kbs (Best Quality)', 256]],
      video_formats: [['AVI', 'avi'], ['MOV', 'mov'], ['MP4 (Recommended)', 'mp4'], ['3GP', '3gp'], ['WEBM', 'webm'], ['OGV', 'ogv']],
      watermark_location: [['Top Left', 'top|left'], ['Top Center', 'top|center'], ['Top Right', 'top|right'], ['Bottom Left', 'bottom|left'], ['Middle Left', 'middle|left'], ['Middle Center', 'middle|center'], ['Middle Right', 'middle|right'], ['Bottom Center', 'bottom|center'], ['Bottom Right', 'bottom|right'] ],
      no_spaces_error: 'Field may not have spaces in it, please replace spaces with `_` or `-`.',
    },
    validator: { 
      perform:  lambda do |key, options|
        if options[:validated]
          "Success: Validation type #{options[:type]} validates against provided input of '#{options[:input]}'."
        else 
          "Error: Validation type #{options[:type]} does not validate against provided input of '#{options[:input]}'."
        end
      end 
    }
    # api: { 
    #   v1: { 
    #     validation: { 
    #       text_length: { 
    #         no_string: 'There was no text provided so no validation can take place.',
    #         valid: lambda do |key, options|
    #           if options[:validated]
    #             'The text provided fits between the min and max of the selected type.'
    #           else 
    #             'The text provided fails because it is not between the min and max values of the selected type.'
    #           end 
    #         end 
    #       },
    #       numerical: { 
    #         no_number: 'There was no number provided for validation.',
    #         no_step: 'There was no step value provided.',
    #         no_validation: 'There is no validation to perform, returning true.',
    #         step: lambda do |key, options|
    #           if options[:validated]
    #             'The number is a multiple of the step value.'
    #           else 
    #             'The step value is not divisible by the number provided.'
    #           end 
    #         end, 
    #         min_max: lambda do |key, options|
    #           if options[:validated]
    #             'The number fits between the min and max values.'
    #           else 
    #             'The number does not fit between the min and max values provided.'
    #           end 
    #         end
    #       },
    #       regex: { 
    #         no_expression: 'You do not have an expresion to compare with, please edit the form with a valid regex',
    #         valid: lambda do |key, options|
    #           if options[:validated]
    #             "The input matches the expected result using the regular expression provided."
    #           else 
    #             "The input does not match the expected result using the regular expression provided."
    #           end
    #         end 
    #       },
    #       type: { 
    #         valid: lambda do |key, options|
    #           if options[:validated]
    #             "Validation type #{options[:type]} validates against the #{options[:input]}."
    #           else 
    #             "Validation type #{options[:type]} does not validate against the #{options[:input]}."
    #           end
    #         end 
    #       },
    #     }
    #   }
    # }
  }
}
          