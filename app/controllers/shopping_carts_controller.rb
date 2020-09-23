class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: [:show, :edit, :update, :destroy]

  # GET /shopping_carts
  # GET /shopping_carts.json
  def index
    @shopping_carts = ShoppingCart.all
  end

  # GET /shopping_carts/1
  # GET /shopping_carts/1.json
  def show
  end

  # GET /shopping_carts/new
  def new
    @shopping_cart = ShoppingCart.new
  end

  # GET /shopping_carts/1/edit
  def edit
  end

  # POST /shopping_carts
  # POST /shopping_carts.json
  def create
    @shopping_cart = ShoppingCart.new(shopping_cart_params)

    respond_to do |format|
      if @shopping_cart.save
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully created.' }
        format.json { render :show, status: :created, location: @shopping_cart }
      else
        format.html { render :new }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_carts/1
  # PATCH/PUT /shopping_carts/1.json
  def update
    respond_to do |format|
      if @shopping_cart.update(shopping_cart_params)
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @shopping_cart }
      else
        format.html { render :edit }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_carts/1
  # DELETE /shopping_carts/1.json
  def destroy
    @shopping_cart.destroy
    respond_to do |format|
      format.html { redirect_to shopping_carts_url, notice: 'Shopping cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def addtocart
    pid = params[:id]
    pqty = params[:qty]
    if session[:shoppingcart] != nil or defined?(session[:shoppingcart]["cid"]) != nil
       session[:shoppingcart]["items"] << pid+","+pqty+":"
       product = Product.find(params[:id])
       product.update(:quantity =>  (product.quantity - 1))
    else
       session[:shoppingcart] = ShoppingCart.new()
       session[:shoppingcart].cid = 1
       session[:shoppingcart]["items"] = pid+","+pqty+":" 
    end
    puts(session[:shoppingcart])
  end

def removefromcart
    pid = params[:id]
    pqty = params[:qty]
    if session[:shoppingcart] != nil or defined?(session[:shoppingcart]["items"]) != nil
       if session[:shoppingcart]["items"].slice!(pid+","+pqty+":") != nil 
          session[:shoppingcart]["items"].slice!(pid+","+pqty+":")
          product = Product.find(params[:id])
          product.update(:quantity =>  (product.quantity + 1))
          @notice = 'removed Shopping cart.'
       else
          @notice = 'Shopping cart is empty.'
       end
    else
       @notice = 'Shopping cart is empty.'
    end
    puts(session[:shoppingcart])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = ShoppingCart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shopping_cart_params
      params.require(:shopping_cart).permit(:cid, :items)
    end
end
