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

puts "You are " + age + " years old, " + height + "cm tall, and " + weight + "kg"
puts divider
puts "We will calculate the target calories in the next section"

# for now we can start other parts of the application, like displaying a menu for the application
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
  puts
end
