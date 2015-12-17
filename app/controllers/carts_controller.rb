class CartsController < ApplicationController
  skip_before_action :authorize, only: [:create, :update, :destroy]
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def index
    @carts = Cart.all
  end

  def show
  end

  def new
    @cart = Cart.new
  end

  def edit
  end

  def create
    @cart = Cart.new(cart_attributes)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart.update(cart_attributes)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # FIXME_SG: What if cart can not be destroyed?
    # FIXME_SG: try again
    if @cart.id == session[:cart_id]
      @cart.destroy
    else
      flash[:notice] = "Can't be deleted"
    end
    session.delete(:cart_id)
    respond_to do |format|
      format.html { redirect_to store_url }
      format.json { head :no_content }
    end
  end

  private

    # FIXME_SG: either always use indentation for private method or never be consistent!

    def invalid_cart
      # FIXME_SG: spacing
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end

    def set_cart
      @cart = Cart.find(params[:id])
    end

    # FIXME_SG: rename this method
    def cart_attributes
      # FIXME_SG: use params.require.permit()
      params.require(:cart)
      # Never trust parameters from the scary internet, only allow the white list through.
    end
end
