class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:failure]

  def home
  end

  def failure
  end
end
