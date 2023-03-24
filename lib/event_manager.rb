# frozen_string_literal: true

require 'csv'
puts 'Event Manager Initialized!'

# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index.zero?

#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# contents = CSV.open('event_attendees.csv', headers: true)
# contents.each do |row|
#   name = row[2]
#   puts name
# end
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
