# app/controllers/api/v1/projects_controller.rb

# A reboot of the app means we will start from v1 of the API.
# Has many of the same functionality of the old APIs.
# @author David J. Davis
class Api::V1::ProjectsController < ApplicationController
  # concerns
  include PrivateApi
end
