cart = {}
total_cart = 0
loop do
  puts 'Введите название товара'
  product = gets.chomp
  break if product == 'стоп'
  puts 'Введите цену за единицу'
  price = gets.chomp.to_f
  puts 'Введите количество товара'
  amount = gets.chomp.to_f
  cart[product] = { price: price, amount: amount }
end
cart.each do |product, item|
  puts "#{product}, Цена: #{item[:price]}  Количество: #{item[:amount]}, Итого: #{item[:price] * item[:amount]}"
  total_cart += item[:price] * item[:amount]
end
puts "Сумма всех покупок: #{total_cart}"
