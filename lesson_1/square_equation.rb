puts "Введите значение A "
a = gets.chomp.to_i
puts "Введите значение B "
b = gets.chomp.to_i
puts "Введите значение C "
c = gets.chomp.to_i
D = (b**2 - 4 * a * c).to_i
if D > 0
  X1 = (-b + Math.sqrt(D))/(2 * a)
  X2 = (-b - Math.sqrt(D))/(2 * a)
  puts "Дискриминант = #{D}. x1 = #{X1}. x2 = #{X2}"
elsif D == 0
  X = (-b)/(2 * a)
  puts "Дискриминант = #{D}. x1 = #{X} (т.к. корни в этом случае равны)"
elsif D < 0
  puts "Дискриминант = #{D}. Корней нет!"
end
