class LicensesController < ApplicationController
  before_filter :require_login
  #before_filter :find_license, :except => [:index, :new, :create, :add_products, :remove_product]
  before_filter :build_new_license_from_params
  before_filter :clear_session_vars, :only => [:new]
  before_filter :build_product_licenses_from_params, :only => [:create, :update]
  before_filter :get_related_resources, :except => [:index, :show, :destroy]
  after_filter :set_session_vars, :only => [:add_products, :remove_product]
  after_filter :clear_session_vars, :only => [:create]

  def index
    @licenses = policy_scope(License)
  end

  def show
    authorize @license
  end

  def new
    authorize @license
  end

  def create
    authorize @license

    @license.attributes = params[:license]

    respond_with(@license) do |format|
      if @license.save
        format.html {
          flash[:notice] = t(:notice_successful_create) + " by " + current_user.to_s
          redirect_to(params[:continue] ? new_license_path : licenses_path)
        }
      else
        format.html {render :new}
      end
    end
  end

  def edit
    authorize @license
  end

  def update
    authorize @license
    @license.attributes = params[:license]

    respond_with(@license) do |format|
      if @license.save
        format.html {
          flash[:notice] = t(:notice_successful_update)
          render :show_license_path
        }
      else
        format.html {render :edit}
      end
    end

  end

  def destroy
    authorize @license
    @license.destroy

    respond_with(@license) do |format|
      format.html {redirect_to(licenses_path)}
    end
  end

  def add_products
    authorize @license, :update?

    prods = Product.where(:id => (params[:license][:product_id] || params[:license][:product_ids])).all
    @license.products << prods if request.post?
    @products -= prods
    @product_ids = prods.map(&:id)
    respond_with(@license) do |format|
      format.html { redirect_to edit_license_path(@license) }
      format.js
    end
  end

  def remove_product
    authorize @license, :update?

    if request.delete? and @license.products.delete(Product.find(params[:product_id]))
      @product_id = params[:product_id]
      @products << Product.find(@product_id)
    else
      @product_id = '0'
    end
    respond_with(@license) do |format|
      format.html { redirect_to edit_license_path(@license) }
      format.js
    end
  end

  private

  def find_license
    @license = License.includes(:products, :product_licenses).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def build_new_license_from_params
    if params[:id].blank? or params[:id].to_i == 0
      @license = License.new
      @license.author = current_user
    else
      find_license()
    end
  end

  def get_related_resources
    @product_families = policy_scope(ProductFamily)
    @users= User.active
    if @license.new_record?
      @products = session[:products] || policy_scope(Product)
    else
      @products = policy_scope(Product) - @license.products
    end
  end

  def set_session_vars
    session[:products] = @products
  end

  def clear_session_vars
    session.delete(:products)
  end

  def build_product_licenses_from_params
    pl_params = Hash.new
    if !params[:license].nil? and !params[:license][:product_licenses].nil?
      pl_params = params[:license].delete(:product_licenses)
    elsif !params[:product_licenses].nil?
      pl_params = params[:product_licenses]
    end

    # This is require when client side doesn't support AJAX
    p_id = params[:license].delete(:product_id)
    unless p_id.empty?
      pl_params[p_id] = { :product_id => p_id }
    end

    if pl_params.any?
      pl_params.each do |p_id, pl_attr|
        if @license.product_licenses.exists?(:product_id => p_id)
          pl = @license.product_licenses.find(:first, :conditions => {:product_id => p_id})
          pl.attributes = pl_attr
          @license.product_licenses << pl
        else
          @license.product_licenses.build(pl_attr)
        end
      end
    end
  end

end
