class ProductsController < ApplicationController
  before_filter :require_login
  before_filter :find_product, :except => [:index, :new, :create]

  def index
    @products = policy_scope(Product)
  end

  def show
    authorize @product
  end

  def new
    @product = Product.new
    authorize @product
    @product_families = policy_scope(ProductFamily)
  end

  def create
    @product = Product.new
    authorize @product
    @product.attributes = params[:product]

    respond_with(@product) do |format|
      if @product.save
        format.html {
          flash[:notice] = t(:notice_successful_create)
          redirect_to(params[:continue] ? new_product_path : products_path)
        }
      else
        format.html {render :new}
      end
    end

  end

  def edit
    authorize @product
    @product_families = policy_scope(ProductFamily)
  end

  def update
    authorize @product
    @product.attributes = params[:product]
    respond_with(@product) do |format|
      if @product.save
        format.html {
          flash[:notice] = t(:notice_successful_update)
          render :show_product_path
        }
      else
        format.html {render :edit}
      end
    end

  end

  def destroy
    authorize @product
    respond_with(@product) do |format|
      format.html {redirect_to(products_path)}
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
