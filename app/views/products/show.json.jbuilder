#json.partial! "products/product", product: @product

json.array! @products, partial: "products/product", as: :product
