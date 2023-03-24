# frozen_string_literal: true

puts 'Event Manager Initialized!'

# contents = File.read('event_attendees.csv')

# puts File.exist?('event_attendees.csv')

# lines = File.readlines('event_attendees.csv')
# row_index = 0
# lines.each do |line|
#   row_index += 1
#   next if row_index == 1

#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line, index|
  next if index.zero?

  columns = line.split(',')
  name = columns[2]
  puts name
end
