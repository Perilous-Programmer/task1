
#CHALLENGE 1.

Your task is to implement backend application library to product catalog and shopping
basketof a web shop.

Product catalog contains at least names, amounts for sale (i.e. stock) and prices of
available products. Shopping basket contains products from catalog and to-bepurchased
amounts. Don’t forget to keep the product catalog up to date: products and
stocks are updated based on the reservations in the basket.

We need the following functions:
- Adding/removing/editing products in product catalog
- Adding/removing/editing products in shopping basket
- Querying products from product catalog with basic pagination (e.g. 100
products / query), sorted by given sorting key (name or price).
- Querying products from product catalog, grouped by price ranges (with a
single function call, fully customizable via input data, example of range set:
cheaper than 5 €, 5-10€, more expensive than 10€).
- Searching product from catalog by matching the beginning of product name,
filtering the results within given price range (min, max), and sorting by given
key (name or price).

We appreciate good programming practices (e.g. tests) and readability of your
solution.

You can employ any programming language and use freely any open source software
libraries. To store data, you can use suitable database engine.

# implementation
- The files containing the logic are in the controller folder i.e. product and shoppingcart. 
- A simple interface is available for testing when the rails server is run. 
- All the methods are implemented using keyword arguments.
