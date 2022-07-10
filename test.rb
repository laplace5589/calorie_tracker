app_name = "Calorie Tracker App"
divider = "=============================================="
greeting = "Hello, whose calories are we tracking?"
terminal_input = ">"
terminal_finished = "<"

puts app_name
puts divider
puts greeting

puts terminal_input
user_name = gets.chomp
puts terminal_finished

puts "Hello " + user_name + ", we will be taking in information to calculate your calorie targets"

puts "How old are you?"
puts terminal_input
age = gets.chomp
puts terminal_finished

puts "How tall are you in cm"
puts terminal_input
height = gets.chomp
puts terminal_finished

puts "How much do you weigh in kg"
puts terminal_input
weight = gets.chomp
puts terminal_finished

puts %{What kind of activity do you take part in during the week
0) Sedentary
1) Light
2) Moderate
3) Active
}
puts terminal_input
activity = gets.chomp
puts terminal_finished

# we will now use the if-check code to set the actvity_factor
activity_factor = 1.2
if activity == "1"
  activity_factor = 1.375
end
if activity == "2"
  activity_factor = 1.55
end
if activity == "3"
  activity_factor = 1.725
end

puts %{What level of body fat content do you have?
0) High
1) Medium
2) Low
}
puts terminal_input
body_fat = gets.chomp
puts terminal_finished

# we will now use the if-check code to set the body fat content deficit we need
body_fat_deficit = 500
if body_fat == "1"
  body_fat_deficit = 250
end
if body_fat == "2"
  body_fat_deficit = 100
end


puts "You are " + age + " years old, " + height + "cm tall, and " + weight + "kg"
puts "Activity factor is: " + activity_factor.to_s + ", body fat deficit we will use is: " + body_fat_deficit.to_s
puts divider

base_energy = (weight.to_i * 10) + (height.to_i * 6.25) + (age.to_i * 5)
puts "Your base energy needs are: " + base_energy.to_s + " calories"

total_energy_spent = base_energy * activity_factor
puts "Your total energy expenditure is: " + total_energy_spent.to_s + " calories"

calorie_deficit_target = total_energy_spent - body_fat_deficit
puts "Your calorie deficit target is: " + calorie_deficit_target.to_s + " calories"

puts

running = true
while running
  puts %{What do you want to do?
  0) Quit
  1) See ingredients in DB
  2) Add new ingredient
  3) See foods in DB
  4) Add new food
  5) See current macros
  6) Track macros for meal
  7) See food suggestions
  }
  menu_value = gets.chomp
  puts "The value that was input was: " + menu_value

  if menu_value == "0"
    running = false
  end
  if menu_value == "5"
    calories_eaten = 0
    puts "Calories eaten so far: " + calories_eaten.to_s + " / " + calorie_deficit_target.to_s
  end
  puts
end

# this handles variables, input, output
# type changes, if checks for exact values
# and an while loop with a boolean variable
#
# notes:
# it took 3 pomodoros back to back to record
# should stop calling things values - and use variables
# should explain methods/functions??? for strings so we can use chomp
# should explain keywords??? so we can reference them as we go on
# need to include types so we can turns ints into strings and floats
# need to review these different types and what they mean
# if check needs to come in before the while loop
# right after types
# because once we have types we can do math
# order should be:
#
# variables
# puts
# gets
# types
# math
# if check
# while
#
# what would follow is "script with flow and loops"
# it could mean the rest of the menu doing something
# I think it would be good to bring in functions to move down code that won't change anymore
# also for the menu portion to be clean and the code run for each function
# small functions for each portion of the code and functions with functions call
#
# don't worry about other loops that have to do with users, and so on until much later, after we have classes maybe
# we do want to have loops for going over ingredients and foods
# but that would have to come after using the file library, possibly rationals, is there a need for Random?
# maybe look for other classes from vanilla Ruby that would make sense, like Time, etc
