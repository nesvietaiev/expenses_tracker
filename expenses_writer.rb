require 'rexml/document'
require 'date'

puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

puts "Укажите дату в формате ДД.ММ.ГГГГ, например 17.12.2016 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

expense_date = nil

if date_input == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "В какую категорию занести товар?"
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

file = File.new(file_name, "r:UTF-8")
doc = REXML::Document.new(file)
file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
    'date' => expense_date.to_s,
    'category' => expense_category,
    'amount' => expense_amount
}

expense.text = expense_text
file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close

puts "Запись успешно сохранена"




