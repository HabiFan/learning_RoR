puts "Введите 1 сторону треугольника: "
a = gets.chomp.to_i
puts "Введите 2 сторону треугольника: "
b = gets.chomp.to_i
puts "Введите 3 сторону треугольника: "
c = gets.chomp.to_i
if (a > b) && (a > c)
  max = a
  sum_right = (b**2) + (c**2)
elsif (b > a) && (b > c)
  max = b
  sum_right = (a**2) + (c**2)
else
  max = c
  sum_right = (a**2) + (b**2)
end
if (max**2) == sum_right
  puts "Треугольник равнобедренные и равносторонний"
end
