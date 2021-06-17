# Factory Builder
# @author David J. Davis / Tracy McCormick
class Conversion::Actor
  TYPES = [
    Conversion::Image,
    Conversion::Audio,
    Conversion::Video,
    Conversion::Pdf
  ].freeze

  # Constructor function
  # @params[media] Object call of the media object in the actor class.
  # @params[conversion_params] Hash of the conversion params from the form.
  # @author David J. Davis
  def initialize(media_id, conversion_params)
    @media = Media.find(media_id)
    @conversion_params = conversion_params
    conversion
  end

  # Sets up the conversions that will be called.  If the matcher is accepted.
  # @return Class [Object]
  # @author David J. Davis
  def conversion
    @conversion = TYPES.select do |conversion_type|
      conversion_type.matches?(@media.mime_type)
    end.first
  end

  # Perform is a connector service that performs the actual conversions
  # using the proper class.
  # @return [Boolean || String] it will either pass with a boolean or send
  # back an error string from the kernal operation.
  # @author David J. Davis
  def perform
    @conversion.new(@media, @conversion_params).perform
  end
end
