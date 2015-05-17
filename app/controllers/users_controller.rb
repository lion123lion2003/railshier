class UsersController < ApplicationController
  before_filter :require_login
  before_filter :del_empty_params, :only => [:create, :update]
  before_filter :find_user, :except => [:index, :new, :create, :autocomplete_for_new_user]

  def index
    @users = policy_scope(User)

    respond_with(@users)
  end

  def show
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
    @groups = policy_scope(Group)
    @new_groups = @groups - @user.groups
  end

  def create
    @user = User.new
    authorize @user
    @groups = policy_scope(Group)
    @new_groups = @groups - @user.groups

    unless params[:user][:primary_group_id].nil? or
        params[:user][:group_ids].include?(params[:user][:primary_group_id])
      params[:user][:group_ids] << params[:user][:primary_group_id]
    end
    @user.attributes = params[:user]

    respond_with(@user) do |format|
      if @user.save
        format.html {
          flash[:notice] = t(:notice_successful_create)
          redirect_to(params[:continue] ? new_user_path : users_path)
        }
      else
        format.html {render :new}
      end
    end

  end

  def edit
    authorize @user
    @groups = policy_scope(Group)
    @new_groups = @groups - @user.groups
  end

  def update
    authorize @user

    unless params[:user][:primary_group_id].empty? or
        params[:user][:group_ids].include?(params[:user][:primary_group_id])
      params[:user][:group_ids] << params[:user][:primary_group_id]
    end
    @user.attributes = params[:user]

    respond_with(@user) do |format|
      if @user.save
        format.html {
          flash[:notice] = t(:notice_successful_update)
          redirect_to(users_path)
        }
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    authorize @user
    @user.destroy
    respond_with(@user) do |format|
      format.html {redirect_to(users_path)}
    end
  end

  def autocomplete_for_new_user
    results = User.search_ldap_users(params[:term])

    render :json => results.map {|result| {
      'value' => result[:login],
      'label' => "#{result[:login]} (#{result[:firstname]} #{result[:lastname]})",
      'login' => result[:login],
      'firstname' => result[:firstname],
      'lastname' => result[:lastname],
      'email' => result[:email],
      'source' => result[:source]
    }}
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def del_empty_params
    params[:user].delete(:primary_group_id) if params[:user][:primary_group_id].empty?
  end

end
