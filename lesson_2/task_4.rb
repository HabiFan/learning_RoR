my_array = ('a'..'z').to_a
vowels_hash = {}
my_array.select do |v|
  vowels_hash[v] = my_array.index(v) + 1 if v =~/[aeiouy]/
end
vowels_hash.each { |k, v| puts "#{k}-#{v}" }
