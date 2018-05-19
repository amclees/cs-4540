# frozen_string_literal: true

require_relative './quaternion.rb'

input_range = (-4..4)

puts 'How many questions would you like?'
count = gets.chomp.to_i

score = 0.0
max = count.to_f

(1..count).each do |number|
  p = Quaternion.random input_range
  q = Quaternion.random input_range
  answer = p * q

  puts "Question \##{number}: #{p.inspect} * #{q.inspect} = r."
  puts 'What is r_0?'
  w0 = gets.chomp.to_i
  puts 'What is r_1?'
  w1 = gets.chomp.to_i
  puts 'What is r_2?'
  w2 = gets.chomp.to_i
  puts 'What is r_3?'
  w3 = gets.chomp.to_i

  input_answer = Quaternion.new(w0, w1, w2, w3)

  if answer == input_answer
    puts 'Correct!'
    score += 1.0
  else
    puts "Wrong. The correct answer was #{answer.inspect}"
  end
end

puts "You scored a #{100.0 * score / max}"
