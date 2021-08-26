class ProjectsController < ApplicationController

  # GET /projects
  def index
    breadcrumb 'Select Project', '/projects', title: 'List Objects - Select Project', match: :exact
    @projects = Project.all.order(:name)
  end

end
