class CartsController < ApplicationController
  skip_before_action :authorize, only: [:create, :update, :destroy]
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # FIXME_SG: remove useless comments. you should add more meaningfull comments!

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
    if @cart.id == session[:cart_id]
      @cart.destroy
    # FIXME_SG: Use session.delete
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

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end

    def set_cart
      @cart = Cart.find(params[:id])
    end

    def cart_attributes
      params.require(:cart)
    # Never trust parameters from the scary internet, only allow the white list through.
    # FIXME_SG: use params.require
    # FIXME_SG: rename this method
    end
end
