puts "Введите 1 сторону треугольника: "
a = gets.chomp.to_i
puts "Введите 2 сторону треугольника: "
b = gets.chomp.to_i
puts "Введите 3 сторону треугольника: "
c = gets.chomp.to_i
a_side, b_side, c_side = [a, b, c].sort
if (c_side ** 2) == (a_side ** 2) + (b_side ** 2)
  puts "Треугольник прямоугольный"
elsif a_side == b_side || b_side == c_side || a_side == c_side
  puts "Треугольник равнобедренный"
elsif a_side == b_side && b_side == c_side
  puts "Треугольник равнобедренный и равносторонний"
else
  puts "Треугольник разносторонний, но не прямоугольный"
end
