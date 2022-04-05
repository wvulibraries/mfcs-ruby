# app/controllers/admin/projects_controller.rb
# Admin Projects Controller
class Admin::ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Projects', '/admin/projects', title: 'Admin', match: :exact
    @projects = Project.all
  end

  # GET /projects/1
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to [:admin, @project], notice: I18n.t('project.created')
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to [:admin, @project], notice: I18n.t('project.updated')
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to admin_projects_url, notice: I18n.t('project.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.fetch(:project, {}).permit(:name, :project_id)
  end
end
