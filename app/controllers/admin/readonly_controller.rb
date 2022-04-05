# app/controllers/admin/readonly_controller.rb
# Admin Readonly Controller
class Admin::ReadonlyController < ApplicationController
  before_action :set_system_readonly, only: [:index, :toggle]

  # to do only allow admins to set read only mode

  # GET /admin/readonly
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Readonly', '/admin/readonly', title: 'Read Only', match: :exact
  end

  def toggle
    # update System Read Only Entry
    @system_readonly.value = !@system_readonly.value
    @system_readonly.save
    @mode = @system_readonly.value == true ? 'Read Only Mode' : 'Write Mode'
    redirect_to :admin_index_readonly
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_system_readonly
    @system_readonly = System.where(name: 'readonly').first
    if @system_readonly.nil?
      @system_readonly = System.create(name: 'readonly', value: 'false')
    end

    @mode = @system_readonly.value == true ? 'Read Only Mode' : 'Write Mode'
  end
end
