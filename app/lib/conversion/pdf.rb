class Conversion::Pdf
  def self.matches?(mime)
    %w[application
       text].include?(mime.split('/')[0].downcase) && mime.split('/')[1].downcase.include?('pdf')
  end

  # Constructor function
  # @params[media] Object call of the media object in the actor class.
  # @params[conversion_params] Hash of the conversion params from the form.
  # @author(s) David J. Davis / Tracy A. McCormick
  def initialize(media_id, conversion_params)
    @media = Media.find(media_id)
    @conversion_params = conversion_params
  end

  def perform; end
end
