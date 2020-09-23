class ProductsController < ApplicationController
  before_action :get_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
    puts(product_params)
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tocart
    redirect_to controller: 'shopping_carts', action: 'addtocart', qty: "1"
  end

  private
    # genral method for testing from uri
    def get_product
      # all item in range 10 i.e products/range5-10
      if params[:id] =~ /\Arange\d+-\d+\z/
         # size = params[:id].size
         # prices = params[:id][5,size]
         # down, up = prices.split("-")
         # Upper expressions ziped into 1 expression 
         down , up = (params[:id][5,params[:id].size]).split("-")
         @products = search_range(up.to_i(),down.to_i())
      # all item expensive than 10 i.e products/range10- 
      elsif params[:id] =~ /\Arange\d+-\z/
         down = params[:id][5,params[:id].size][0..-2]
         @products = search_above(down.to_i())
      # all item cheaper than 5 i.e products/range-5
      elsif params[:id] =~ /\Arange-\d+\z/
         up = params[:id][5,params[:id].size][1..]
         @products = search_below(up.to_i())
      # item by name, range, sorting, sort by i.e products/range125-129-asc-price-itemname
      elsif params[:id] =~ /\Arange\d+-\d+-(asc|desc)-(name|price)-\D+\z/
         # size = params[:id].size
         # prices = params[:id][5,size]
         # down, up, sorting, sortby, name = prices.split("-")
         # Upper expressions ziped into 1 expression 
         down , up, sorting, sortby, name = (params[:id][5,params[:id].size]).split("-")
         @products = search_by_name(name: name,max_price: up.to_i(), min_price: down.to_i(),order: sorting, sort_by: sortby)
      # item by name, range and sorting i.e products/range125-129-asc-itemname
      elsif params[:id] =~ /\Arange\d+-\d+-(asc|desc)-\D+\z/
         # size = params[:id].size
         # prices = params[:id][5,size]
         # down, up, sorting, name = prices.split("-")
         # Upper expressions ziped into 1 expression 
         down , up, sorting, name = (params[:id][5,params[:id].size]).split("-")
         @products = search_by_name(name: name,max_price: up.to_i(), min_price: down.to_i(),order: sorting)
      # item by name, range i.e products/range125-129-itemname
      elsif params[:id] =~ /\Arange\d+-\d+-\D+/
         # size = params[:id].size
         # prices = params[:id][5,size]
         # down, up, name = prices.split("-")
         # Upper expressions ziped into 1 expression 
         down , up, name = (params[:id][5,params[:id].size]).split("-")
         @products = search_by_name(name: name,max_price: up.to_i(), min_price: down.to_i())
      # for pagination  i.e products/page-1-items-1-sort-price-asc
      elsif params[:id] =~ /page-\d+-items-\d+-sort-(name|price)-(asc|desc)\z/
         p, page, i, items, s, sortby, sorting = params[:id].split("-")
         @products =paginate(page: page.to_i(), per_page: items.to_i(),order: sorting, sort_by: sortby)
      # for pagination  i.e products/page-1-items-1
      elsif params[:id] =~ /page-\d+-items-\d+\z/
         p, page, i, items = params[:id].split("-")
         @products =paginate(page: page.to_i(), per_page: items.to_i())
      # for show, edit, delete, update
      elsif params[:id] =~ /\d+\z/
         @products = Product.where("id = ?", params[:id])
      else
      # item by name i.e products/itemname
         @products = search_by_name(name: params[:id])
      end
    end
      # all item by name
    def search_by_name(name:, max_price: 0, min_price: 0,sort_by: "price",order: "asc")
        if min_price>0 || max_price>0
            return Product.where("name LIKE ? AND (price BETWEEN ? AND ?) ", (name << '%'), min_price, max_price).order((sort_by == "price" ? "price" : "name")+" "+(order == "asc" ? "ASC" : "DESC"))
        else
            return Product.where("name LIKE ?", (name << '%')).order((sort_by == "price" ? "price" : "name")+" "+(order == "asc" ? "ASC" : "DESC"))
        end
    end
      # all item in range 10 i.e products/range5-10
    def search_range(up=0,down=0)
        # all item expensive than 10 i.e products/range10-0 
        if up == 0 and down != 0
           return Product.where("price > ?", down)
        # all item cheaper than 5 i.e products/range0-5
        elsif up != 0 and down == 0
           return Product.where("price < ?", up)
        else
           return Product.where("price BETWEEN ? AND ?", down, up)
        end
    # pagination with sorting function
    def paginate(page:, per_page:, sort_by: "price",order: "asc")
    return Product.select("*").offset(offfset(page: page,per_page: per_page)).limit(per_page).order((sort_by == "price" ? "price" : "name")+" "+(order == "asc" ? "ASC" : "DESC"))
    end
    # pagination offset humanizator
    def offfset(page:, per_page:)
    return (page-1) * per_page
    end

    end
      # all item expensive than 10 i.e products/range10- 
    def search_above(down=0)
        return Product.where("price > ?", down)
    end
      # all item cheaper than 5 i.e products/range-5
    def search_below(up=0)
        return Product.where("price < ?", up)
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:pid, :category, :name, :quantity, :price)
    end
end
