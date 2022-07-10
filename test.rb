# app_name here is the variable name, in Ruby we normally write _ between words
# when we want to use text values, we surround them in ""
app_name = "Calorie Tracker App"
divider = "=============================================="
greeting = "Hello, whose calories are we tracking?"
terminal_input = ">"
terminal_finished = "<"

puts app_name
puts divider
puts greeting

# the keyword gets grabs a value input into the terminal to be used in the code
# in this case we assign the value into the variable on the left side
# to finish imputting a value on the terminal, one presses enter
puts terminal_input
user_name = gets
puts terminal_finished

# we use a '+' sign to combine different text values
puts "Hello, " + user_name

puts "Now that we're done with the basics of text variables, putting values to the terminal, and inputting values to the terminal, we'll stop this section and save"


# to execute the application we write >ruby <file_name.rb>
# the program will run from top to bottom line by line
# we can trace the execution by adding -r debug to the command
# once the app has started the keyword 'n' will move to the next step
# the first 2 times get into the program execution
# then each line being executed is printed on the terminal and by inputting 'n'ext
# we can see the next line of the program being executed
