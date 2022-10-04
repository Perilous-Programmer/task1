json.extract! product, :id, :pid, :category, :name, :quantity, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
