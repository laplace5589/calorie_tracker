# require 'pry'; binding.pry

module Sex
  MALE = 5
  FEMALE = -161
end

app_name = "Calorie Tracker\n"
divider = "=========================================\n"
starter_question = "Who am I tracking?\n"

puts app_name
puts divider

users = {}
if(!File.file?('users.csv')) 
  puts "Users file doesn't exist, so we'll create it now\n"
  File.write("users.csv", "name,age,height,weight,sex")
end

lines = File.open("users.csv").readlines

if lines.count > 1
  puts "Loading users..."
  lines[1..lines.length].each do |line|
    name, age, height, weight, sex = line.split(",")
    users[name] = {
      age: age.to_i, 
      height: height.to_i, 
      weight: weight.to_i, 
      sex: Sex::const_get(sex.strip.upcase)
    }
  end
else
  puts starter_question
  user_names = gets.split(/and|,/).map(&:strip)

  File.open("users.csv", 'a') { |file|
    user_names.each do |user_name|
      user = {name: user_name}

      puts "What is #{user_name}'s age?"
      user[:age] = gets.strip.to_i

      puts "What is #{user_name}'s height in cm?"
      user[:height] = gets.strip.to_i

      puts "What is #{user_name}'s weight in kg?"
      user[:weight] = gets.strip.to_i

      puts "Is #{user_name} male or female?"
      sex_string = gets.strip.upcase
      user[:sex] = Sex::const_get(sex_string)

      file.write("\n#{user[:name]},#{user[:age]},#{user[:height]},#{user[:weight]},#{sex_string}")
    end
  }
end

for user_name, user in users
  user[:base_energy] = (user[:weight]*10)+(user[:height]*6.25)-(user[:age]*5)+user[:sex]
  puts "#{user_name}'s base energy spenditure: #{user[:base_energy]}"
end

if(!File.file?('settings.csv'))
  puts "Settings file doesn't exist, so we'll create it now\n"
  File.write("settings.csv", "activity, fat\n")

  puts divider
  puts %{What was your activity level last week?
  0) sedentary
  1) light
  2) moderate
  3) active

  }
  activity = gets.strip
  activity_factor = (activity == "3" ? 1.725 : (activity == "2" ? 1.55 : (activity == "1" ? 1.375 : 1.2)))

  puts divider
  puts %{What is your body fat content:
  0) high
  1) medium
  2) low

  }
  body_fat = gets.strip
  body_fat_deficit = (body_fat == "2" ? 100 : (body_fat == "1" ? 250 : 500))

  File.open("settings.csv", 'a') { |file|
    file.write("#{activity_factor}, #{body_fat_deficit}\n")
  }
end

settings = File.open("settings.csv").readlines[1]
activity_factor, body_fat_deficit = settings.split(",").map(&:strip).map(&:to_f)

puts divider
for user_name, user in users
  user[:total_energy] = user[:base_energy]*activity_factor
  puts "#{user_name}'s total energy needed is: #{user[:total_energy]}"
end

puts
puts divider
for user_name, user in users
  user[:calorie_target] = user[:total_energy]-body_fat_deficit
  puts "#{user_name}'s calorie target is: #{user[:calorie_target]}"
end


puts divider
puts %{              Macronutrients
=========================================
|   Protein   |   Lipids   |   Carbs   |
-----------------------------------------
}
for _, user in users
  user[:protein_target] = 1.6*user[:weight]
  fat_percentage = (user[:sex] == Sex::MALE ? 0.2 : 0.3)
  user[:fat_target] = (user[:calorie_target]*fat_percentage)/9
  user[:carb_target] = (user[:calorie_target]-(user[:fat_target]*9)-(user[:protein_target]*4))/4
  puts "|    #{user[:protein_target]}g   |" + "   #{"%0.2f" % user[:fat_target]}g   |" + "  #{"%0.2f" % user[:carb_target]}g  |\n"
end
puts divider
puts

today_file = "#{Time.now.strftime("%D").gsub("/","_")}.csv"
if(!File.file?(today_file))
  puts "File for today doesn't exist, so we'll create it now\n"
  File.write(today_file, "food, who\n")
end

ingredients = {}
ingredients_db = File.open("ingredients.csv").readlines[1..-1]
longest_name = 0
longest_unit = 0

ingredients_db.each do |db_ingredient|
  name, standard, unit, calories, protein, fat, carbs = db_ingredient.split(",").map(&:strip)
  ingredient = {
    standard: Rational(*(standard.split("/").map(&:to_i))),
    unit: unit,
    calories: calories,
    protein: protein,
    fat: fat,
    carbs: carbs
  }
  if name.size > longest_name
    longest_name = name.size
  end
  if unit.size > longest_unit
    longest_unit = unit.size
  end
  ingredients[name] = ingredient
end

foods = {}
foods_db = File.open("foods.csv").readlines[1..-1]

foods_db.each do |db_food|
  name, calories, protein, fat, carbs, _ = db_food.split(",").map(&:strip)
  food = {
    calories: calories,
    protein: protein,
    fat: fat,
    carbs: carbs
  }
  foods[name] = food
end

users.each do |_, user|
  user[:calories_eaten] = 0
  user[:protein_eaten] = 0
  user[:fat_eaten] = 0
  user[:carb_eaten] = 0
end

today_foods = File.open(today_file).readlines[1..-1]
today_foods.each do |today_food|
today_food_name, who = today_food.strip.split(',').map(&:strip)
  users[who][:calories_eaten] += foods[today_food_name][:calories].to_i
  users[who][:protein_eaten] += foods[today_food_name][:protein].to_i
  users[who][:fat_eaten] += foods[today_food_name][:fat].to_i
  users[who][:carb_eaten] += foods[today_food_name][:carbs].to_i
end

done = false
until done
  puts %{What do you want to do?
  0) Quit
  1) See ingredients are on the database
  2) Add a new ingredient
  3) See foods are on the database
  4) Add a new food
  5) See current macros
  6) Track macros for meal
  7) See food suggestions
  }
  case gets.to_i
  when 0
    done = true
  when 1
    ingredients.each do |n, v|
      puts "#{n} #{" "*(longest_name-n.size)} #{v[:standard]} #{v[:unit]} #{" "*(longest_unit-v[:unit].size)} #{v[:calories]}    #{v[:protein]} | #{v[:fat]} | #{v[:carbs]}"
    end
    puts
    puts
  when 2
    puts "Add ingredient name, standard, unit, calories, protein, fat, carbs"
    name, standard, unit, calories, protein, fat, carbs = gets.split(",").map(&:strip)
    File.open("ingredients.csv", 'a') { |file|
      file.write("#{name}, #{standard}, #{unit}, #{calories}, #{protein}, #{fat}, #{carbs}\n")
    }
    ingredients[name] = {
      standard: Rational(*(standard.split("/").map(&:to_i))),
      unit: unit,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs
    }
    puts
    puts
  when 3
    puts File.open("foods.csv").readlines[1..-1]
    puts
    puts
  when 4
    puts "Add food name, ingredients(amount)_"
    food_name, food_ingredients = gets.split(",").map(&:strip)
    food_calories = 0
    food_protein = 0
    food_fat = 0
    food_carbs = 0

    food_ingredient_list = food_ingredients.split("_")
    food_ingredient_list.each do |food_ingredient|
      name, amount = food_ingredient.split("(")
      ingredient = ingredients[name]

      unless ingredient
        ingredient = foods[name]
      end
      if ingredient
        ingredient[:standard] ||= 1
        factor = Rational(*(amount[0..-2].split("/").map(&:to_i))) / ingredient[:standard]
        food_calories += ingredient[:calories].to_i*factor
        food_protein += ingredient[:protein].to_i*factor
        food_fat += ingredient[:fat].to_i*factor
        food_carbs += ingredient[:carbs].to_i*factor
      else
        puts "couldn't find ingredient: " + name + " in databases"
      end
    end

    File.open("foods.csv", 'a') { |file|
      file.write("#{food_name}, #{"%0.2f" % food_calories.to_f}, #{"%0.2f" % food_protein.to_f}, #{"%0.2f" % food_fat.to_f}, #{"%0.2f" % food_carbs.to_f}, #{food_ingredients}\n")
    }
    foods[food_name] = {
      calories: food_calories,
      protein: food_protein,
      fat: food_fat,
      carbs: food_carbs
    }
    puts
    puts
  when 5
    users.each do |user_name, user|
      puts "#{user_name}:"
      puts "    calories - #{user[:calories_eaten]} / #{"%0.2f" % user[:calorie_target]}"
      puts "    protein  - #{"%0.2f" % user[:protein_eaten]} / #{"%0.2f" % user[:protein_target]}"
      puts "    fats     - #{"%0.2f" % user[:fat_eaten]} / #{"%0.2f" % user[:fat_target]}"
      puts "    carbs    - #{"%0.2f" % user[:carb_eaten]} / #{"%0.2f" % user[:carb_target]}"
    end
    puts
    puts
  when 6
    puts "Who is eating this meal?"
    user_name = gets.strip
    puts "How many foods are part of the meal?"
    meals = gets.strip.to_i
    (1..meals).each do |meal|
      puts "Which food do we track?"
      food_name = gets.strip
      food = foods[food_name]
      unless food
        puts "Couldn't find #{food_name} in:"
        puts File.open("foods.csv").readlines[1..-1]
        puts
      else
        food[:calories]
        File.open(today_file, 'a') { |file|
          file.write("#{food_name}, #{user_name}\n")
        }
      end
    end
    puts
    puts
  when 7
    puts "Who's asking?"
    user = users[gets.strip]
    puts "Foods you can eat:"
    puts "       name        |   calories   |   protein   |    fat    |   carbs   "
    puts "========================================================================"
    foods.each do |food_name, food|
      can_eat_calories = food[:calories].to_f < user[:calorie_target]-user[:calories_eaten]
      can_eat_protein = food[:protein].to_f < user[:protein_target]-user[:protein_eaten]
      can_eat_fat = food[:fat].to_f < user[:fat_target]-user[:fat_eaten]
      can_eat_carbs = food[:carbs].to_f < user[:carb_target]-user[:carb_eaten]
      puts "#{food_name}   |     #{can_eat_calories}     |    #{can_eat_protein}     |    #{can_eat_fat}   |   #{can_eat_carbs}"
    end
    puts
    puts
  else
    puts "That's not an option"
    puts
    puts
  end
end
# require 'pry'; binding.pry
