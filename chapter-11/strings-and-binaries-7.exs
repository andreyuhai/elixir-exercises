defmodule StringsAndBinaries do
  # Exercise:StringsAndBinaries-7
  # Chapter 7 had an exercise about calculating sales tax on page 114 (which I copied below). We now
  # have the sales information in a file of comma-separated id, ship_to, and
  # amount values. The file looks like this
  # id, ship_to, net_amount
  # 123,:NC,100.00
  # 124,:OK,35.50
  # 125,:TX,24.00
  # 126,:TX,44.80
  # 127,:NC,25.00
  # 128,:MA,10.00
  # 129,:CA,102.00
  # 130,:NC,50.00
  #
  # Write a function that reads and parses this file and then passes
  # the result to the sales_tax function.
  # in the string is random.
  def parse_from_file(path) do
    {:ok, res} = File.open(path, [:read], fn file ->
      IO.read(file, :all)
      |> String.split()
      |> Enum.slice(1..-1)
      |> Enum.map(&(String.split(&1, ",")))
    end)

    orders = for [id, ship_to, net_amount] <- res, do: [
    id: String.to_integer(id),
      ship_to: ship_to |> String.replace(":", "") |> String.to_atom(),
      net_amount: net_amount |> String.to_float()
    ]

    MyList.calculate_total_amount(orders, [NC: 0.075, TX: 0.08])
  end
end

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

IO.inspect StringsAndBinaries.parse_from_file("./strings-and-binaries-7.txt")
# =>
# [
#  [id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 100.075],
#  [id: 124, ship_to: :OK, net_amount: 35.5],
#  [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 24.08],
#  [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 44.879999999999995],
#  [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 25.075],
#  [id: 128, ship_to: :MA, net_amount: 10.0],
#  [id: 129, ship_to: :CA, net_amount: 102.0],
#  [id: 130, ship_to: :NC, net_amount: 50.0, total_amount: 50.075]
# ]
