require 'rexml/document'
require 'date'

#находим файл в той же папке, где лежит текущий файл
current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

abort "Извините, файл не найден" unless File.exist?(file_name)

file = File.new(file_name) #создаем новый файл

doc = REXML::Document.new(file) #передаем его в парсер REXML и создаем новый объект doc

amount_by_day = Hash.new #инициализируем пустой хеш

#проходим по XML файлу, подлючаем от туда нужные атрибуты и записываем в массив
doc.elements.each("expenses/expense") do |item|
  loss_sum = item.attributes["amount"].to_i
  loss_date = Date.parse(item.attributes["date"])

  amount_by_day[loss_date] ||= 0

  amount_by_day[loss_date] += loss_sum
end

file.close #закрываем файл, где на выходе содержит хеш(каждой дате соответствует сумма трат)

#инициализируем новый хеш, чтоб узнать сумму трат за каждый месяц
sum_by_month = Hash.new

current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||=0
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

#выводим заголовок для первого месяца
puts "--------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} грн.]------"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "--------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} грн.]------"
  end

  puts "\t #{key.day}: #{amount_by_day[key]} грн."
end