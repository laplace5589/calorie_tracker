module Sex
  MALE = 5
  FEMALE = -161
end

app_name = "Calorie Tracker\n"
divider = "=========================================\n"
starter_question = "Who am I tracking?\n"

puts app_name
puts divider

users = []
if(!File.file?('users.csv')) 
  puts "File doesn't exist, so we'll create it now\n"
  File.write("users.csv", "name,age,height,weight,sex")
end

lines = File.open("users.csv").readlines

if lines.count > 1
  puts "Loading users..."
  lines[1..lines.length].each do |line|
    name, age, height, weight, sex = line.split(",")
    users.append({
      name: name, 
      age: age.to_i, 
      height: height.to_i, 
      weight: weight.to_i, 
      sex: Sex::const_get(sex.strip.upcase)})
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

for user in users
  user[:base_energy] = (user[:weight]*10)+(user[:height]*6.25)-(user[:age]*5)+user[:sex]
  puts "#{user[:name]}'s base energy spenditure: #{user[:base_energy]}"
end

puts divider
puts %{What was your activity level last week?
0) sedentary
1) light
2) moderate
3) active

}
activity = gets.strip
activity_factor = (activity == "3" ? 1.725 : (activity == "2" ? 1.55 : (activity == "1" ? 1.375 : 1.2)))

for user in users
  user[:total_energy] = user[:base_energy]*activity_factor
  puts "#{user[:name]}'s total energy needed is: #{user[:total_energy]}"
end

puts divider
puts %{What is your body fat content:
0) high
1) medium
2) low

}
body_fat = gets.strip
body_fat_deficit = (body_fat == "2" ? 100 : (body_fat == "1" ? 250 : 500))

for user in users
  user[:calorie_target] = user[:total_energy]-body_fat_deficit
  puts "#{user[:name]}'s calorie target is: #{user[:calorie_target]}"
end


puts divider
puts %{
              Macronutrients
========================================
|   Protein   |   Lipids   |   Carbs   |
----------------------------------------
}
for user in users
  user[:protein_target] = 1.6*user[:weight]
  fat_percentage = (user[:sex] == Sex::MALE ? 0.2 : 0.3)
  user[:fat_target] = (user[:calorie_target]*fat_percentage)/9
  user[:carb_target] = (user[:calorie_target]-(user[:fat_target]*9)-(user[:protein_target]*4))/4
  puts "|    #{user[:protein_target]}g   |   #{"%0.2f" % user[:fat_target]}g   |  #{"%0.2f" % user[:carb_target]}g  |\n"
end
