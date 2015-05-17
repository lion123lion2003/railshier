class ProductFamiliesController < ApplicationController
  before_filter :require_login
  before_filter :find_product_family, :except => [:index, :new, :create]

  def index
    @product_families = policy_scope(ProductFamily)
  end

  def show
    authorize @product_family
  end

  def new
    @product_family = ProductFamily.new
    authorize @product_family
  end

  def create
    @product_family = ProductFamily.new
    authorize @product_family
    @product_family.name = params[:product_family][:name]
    @product_family.description = params[:product_family][:description]

    respond_with(@product_family) do |format|
      if @product_family.save
        format.html {
          flash[:notice] = t(:notice_successful_create)
          redirect_to(params[:continue] ? new_product_family_path : product_families_path)
        }
      else
        format.html {render :new}
      end
    end

  end

  def edit
    authorize @product_family
  end

  def update
    authorize @product_family
    @product_family.name = params[:product_family][:name]
    @product_family.description = params[:product_family][:description]
    respond_with(@product_family) do |format|
      if @product_family.save
        format.html {
          flash[:notice] = t(:notice_successful_update)
          render :show_product_family_path
        }
      else
        format.html {render :edit}
      end
    end

  end

  def destroy
    authorize @product_family
    respond_with(@product_family) do |format|
      format.html {redirect_to(product_families_path)}
    end
  end

  private

  def find_product_family
    @product_family = ProductFamily.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
