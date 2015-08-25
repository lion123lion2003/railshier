class GroupsController < ApplicationController

  before_filter :require_login
  before_filter :find_group, :except => [:index, :new, :create]

  def index
    @groups = policy_scope(Group.sorted)

    respond_with(@groups)
  end

  def show
    authorize @group
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new
    authorize @group
    @group.attributes = params[:group]

    respond_with(@group) do |format|
      if @group.save
        format.html {
          flash[:notice] = t(:notice_successful_create)
          redirect_to(params[:continue] ? new_group_path : groups_path)
        }
      else
        format.html {render :new}
      end
    end

  end

  def edit
    authorize @group
    @users = User.active
    @new_users = @users - @group.users
  end

  def update
    authorize @group
    unless params[:group][:primary_user_id].empty?
      params[:group][:user_ids] ||= []
      unless params[:group][:user_ids].include?(params[:group][:primary_user_id])
        params[:group][:user_ids] << params[:group][:primary_user_id]
      end
    end
    @group.attributes = params[:group]
    if params[:group][:user_ids].nil?
      @group.user_ids = []
    end


    respond_with(@group) do |format|
      if @group.save
        format.html {
          flash[:notice] = t(:notice_successful_update)
          #redirect_to(groups_path)
          render :show_group_path
        }
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    authorize @group
    @group.destroy
    respond_with(@group) do |format|
      format.html {redirect_to(groups_path)}
    end
  end

  private

  def find_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
