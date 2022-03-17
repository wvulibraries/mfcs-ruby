# app/controllers/admin/users_controller.rb
# Admin Users Controller
class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /admin/users
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Users', '/admin/users', title: 'Users', match: :exact
    @users = User.all
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit; end

  # POST /admin/users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to [:admin, @user], notice: 'User was successfully created.'
    else
      render :index
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @user.update(user_params)
      redirect_to admin_users_url, success: 'user was successfully updated.'
    else
      render :edit, error: 'user was unable to update.'
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, success: 'user was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.fetch(:user, {}).permit(:id, :name, :image)
  end
end
