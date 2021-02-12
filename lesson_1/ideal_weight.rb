puts "Ваше имя? "
name = gets.chomp
puts "Ваш рост? "
height = gets.chomp.to_f
ideal_weight = (height - 110) * 1.15
if ideal_weight < 0
  puts "Ваш вес уже оптимальный"
else
  puts "#{name} ваш идеальный вес равен - #{ideal_weight}"
end
