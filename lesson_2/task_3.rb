fib = [0, 1]
while (new_num = fib.last(2).sum) < 100
  fib << new_num
end
puts fib
