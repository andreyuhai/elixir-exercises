tax_rates = [NC: 0.075, TX: 0.08]
orders = [
  [id: 123, ship_to: :NC, net_amount: 100.00],
  [id: 124, ship_to: :OK, net_amount: 35.50],
  [id: 125, ship_to: :TX, net_amount: 24.00],
  [id: 126, ship_to: :TX, net_amount: 44.80],
  [id: 127, ship_to: :NC, net_amount: 25.00],
  [id: 128, ship_to: :MA, net_amount: 10.00],
  [id: 129, ship_to: :CA, net_amount: 102.00],
  [id: 130, ship_to: :NC, net_amount: 50.00],
]

defmodule MyList do
  # Exercise:ListsAndRecursion-8
  # Write a function that takes both lists and returns a copy
  # of the orders, but with an extra field, total_amount which is
  # the net plus sales tax. If a shipment is not to NC or TX,
  # there's no tax applied.
  def calculate_total_amount(orders, tax_rates) do
    for order <- orders, {:ship_to, ship_to} <- order do
      if ship_to in Keyword.keys(tax_rates) do
        order ++ [{:total_amount, Keyword.get(order, :net_amount) + Keyword.get(tax_rates, ship_to)}]
      else
        order
      end
    end
  end
end

IO.inspect MyList.calculate_total_amount(orders, tax_rates)
# [
#  [id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 100.075],
#  [id: 124, ship_to: :OK, net_amount: 35.5],
#  [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 24.08],
#  [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 44.879999999999995],
#  [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 25.075],
#  [id: 128, ship_to: :MA, net_amount: 10.0],
#  [id: 129, ship_to: :CA, net_amount: 102.0],
#  [id: 130, ship_to: :NC, net_amount: 50.0, total_amount: 50.075]
#]
