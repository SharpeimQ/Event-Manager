require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'

puts 'Event Manager Initialized!'

hour_counter = Hash.new(0)
most_common_hour = 0

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_numbers(phone_numbers)
  phone_numbers = phone_numbers.to_s.gsub(/\D/, '')  # .gsub(/[()\-. ]/, '') == .gsub(/\D/, '') Removes all non-digit
  if phone_numbers.length == 11 && phone_numbers.start_with?('1')
    phone_numbers[1..].insert(3, '-').insert(7, '-') # forgo the 11 or -1, ruby does it auto
  elsif phone_numbers.length == 10
    phone_numbers.insert(3, '-').insert(7, '-')
  else
    '000-000-0000'
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def popular_hours(times, hour_counter)
  date_time = times.split(' ')
  time_format = '%H:%M'
  time = Time.strptime(date_time[1], time_format)
  hour_counter[time.hour] += 1
  hour_counter.max_by { |hour, value| value }
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  most_common_hour = popular_hours(row[:regdate], hour_counter)

  phone_number = clean_phone_numbers(row[:homephone])

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
end

puts "#{most_common_hour} is/are the most popular hour(s)"