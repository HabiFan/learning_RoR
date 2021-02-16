puts "Введите день (1-31) "
day = gets.chomp.to_i
puts "Введите месяц (1-12) "
month = gets.chomp.to_i
puts "Введите год: "
year = gets.chomp.to_i
f_days = (year % 4).zero? && !(year % 100).zero? || (year % 400).zero? ? 29 : 28
months = [31, f_days, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
puts  "Номер дня введенном году #{(months[0..month-1].sum) - (months[month-1] - day)}"
