# A reboot of the app means we will start from v1 of the API.
# Has many of the same functionality of the old APIs.
# @author David J. Davis
class Api::V1::ValidationController < ApplicationController
  # skips devise
  skip_before_action :authenticate_user!

  # concerns
  include PublicApi
  # include PrivateApi
  # before_action :set_headers,:check_api_key

  # Returns JSON for all forms unless params exist
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def validations
    type = params[:type]
    input = params[:input]

    if type == 'regex' && params[:expression].blank?
      render json: { status: 'false', message: I18n.t('api.v1.validation.regex.no_expression') } and return
    elsif type == 'regex' && params[:expression].present?
      validated_regex = Validator.regex(input, params[:expression])
      render json: { status: validated_regex, message: I18n.t('api.v1.validation.regex.valid', validated: validated_regex) } and return
    elsif type != 'regex'
      valid = Validator.handle_type_validation(input, type)
      render json: { status: valid, message: I18n.t('api.v1.validation.type.valid', validated: valid, input: input, type: type) } and return
    end
  end

  # A numerical validation API for validating the number is between min and max as
  # well as is divisible by the step
  # {status: boolean,msg: string }
  # rubocop:disable Layout/LineLength
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def numerical
    min = define_min params[:min]
    max = define_max params[:max]

    if params[:num].blank?
      render json: { status: 'false', message: I18n.t('api.v1.validation.numerical.no_number') }
    elsif min == max && params[:step].to_i.zero?
      render json: { status: 'true', message: I18n.t('api.v1.validation.numerical.no_validation') }
    elsif min == max && params[:step].to_i.positive?
      step_validation = Validator.divisible_by_step?(params[:num], params[:step])
      render json: { status: step_validation, message: I18n.t('api.v1.validation.numerical.step', validated: step_validation) }
    elsif min < max && params[:step].to_i.positive?
      step_validation = Validator.divisible_by_step?(params[:num], params[:step])
      msg = ''
      msg += I18n.t('api.v1.validation.numerical.step', validated: step_validation)
      number_validated = Validator.between_min_max?(params[:num], min, max)
      msg += I18n.t('api.v1.validation.numerical.min_max', validated: number_validated)
      valid = step_validation && number_validated
      render json: { status: valid, message: msg }
    else
      number_validated = Validator.between_min_max?(params[:num], min, max)
      render json: { status: number_validated, message: I18n.t('api.v1.validation.numerical.min_max', validated: number_validated) }
    end
  end

  # Returns JSON
  # {status: boolean,msg: string }
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def text_length
    if params[:txt_string].blank?
      return render json: { status: 'false', message: I18n.t('api.v1.validation.text_length.no_string') }
    end

    min_text = define_min_text(params[:min])
    max_text = define_max_text(params[:max])
    validated = Validator.text_length(params[:txt_string], min: min_text, max: max_text, type: params[:type])
    render json: { status: validated, message: I18n.t('api.v1.validation.text_length.valid', validated: validated) }
  end

  # Returns JSON
  # {status: boolean,msg: string }
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def duplicates
    if params[:txt_string].blank? && params[:form_id]
      return render json: { status: 'false', message: I18n.t('api.v1.validation.duplicates.no_params') }
    end

    titles = Item.where(form_id: params[:form_id])
                 .pluck("data -> 'title'")
                 .sort.chunk { |e| e }
                 .select { |_e, chunk| chunk.size > 1 }
                 .map(&:first)

    render json: { status: validated, message: I18n.t('api.v1.validation.text_length.valid', validated: validated) }
  end

  private

  # Defines maximum number by setting it to a large value
  # if the number does not exist
  # @author David J. Davis
  # @return Integer
  def define_max(max_param)
    return 1_686_018_427_387_903 if max_param.to_i.zero? # Not quite the biggest,but a really big number anyway

    max_param.to_i
  end

  # Defines the minimum number and keeps it from being nil or blank
  # @author David J. Davis
  # @return Integer
  def define_min(min_param)
    return min_param.to_i if min_param.blank?

    min_param.to_i
  end

  # Defines max number for text strings
  # @author David J. Davis
  # @return Integer
  def define_max_text(max_param)
    return 30_000 if max_param.to_i.zero?

    max_param.to_i
  end

  # Defines min number for text string, same as min for int
  # @author David J. Davis
  # @return Integer
  def define_min_text(min_param)
    define_min(min_param)
  end
end
