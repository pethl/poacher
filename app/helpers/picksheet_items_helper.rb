module PicksheetItemsHelper
  # Figure out which category a product belongs to
  def product_category_for(product,
    sale_product_butter:,
        sale_product_other:,
        cut_guest_cheeses:,
        cheese_accompaniments:,
        sale_product:) # <-- add sale_product here
    return :butter          if sale_product_butter.include?(product)
    return :other           if sale_product_other.include?(product)
    return :cut_guest       if cut_guest_cheeses.include?(product)
    return :accompaniments  if cheese_accompaniments.include?(product)
    return :main            if sale_product.include?(product) # <-- new
    nil
  end

  # A nice label for the category if you want it
  def product_category_label(category)
    {
      butter: "Butter",
      other: "Other Products",
      cut_guest: "Cut Guest Cheeses",
      accompaniments: "Cheese Accompaniments"
    }[category]
  end
end
