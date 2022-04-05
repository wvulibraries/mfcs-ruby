# app/controllers/admin/permissions_controller.rb
# Admin Permissions Controller
class Admin::PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]

  # GET /admin/permissions
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Permissions', '/admin/permissions', title: 'Permissions', match: :exact
    @permissions = Permission.all
  end

  # GET /admin/permissions/1
  def show; end

  # GET /admin/permissions/new
  def new
    @permission = Permission.new
  end

  # GET /admin/permissions/1/edit
  def edit; end

  # POST /admin/permissions
  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      redirect_to [:admin, @permission], notice: I18n.t('permission.created')
    else
      render :new
    end
  end

  # PATCH/PUT /admin/permissions/1
  def update
    if @permission.update(permission_params)
      redirect_to [:admin, @permission], notice: I18n.t('permission.updated')
    else
      render :edit
    end
  end

  # DELETE /admin/permissions/1
  def destroy
    @permission.destroy
    redirect_to admin_permissions_url, notice: I18n.t('permission.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def permission_params
    params.fetch(:permission, {}).permit(:user_id, :form_id, :permission)
  end
end
