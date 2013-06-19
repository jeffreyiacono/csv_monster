# ExtendedCSV

```ruby
require './lib/extended_csv'

first  = ExtendedCSV.new 'first.csv'
second = ExtendedCSV.new 'second.csv'
parts  = ExtendedCSV.new ['first.csv', 'second.csv']
whole  = ExtendedCSV.new 'first_and_second_already_combined.csv'

# using the + operator
puts (whole == (first + second)) ? "matchy!" : "no matchy!"

# using the initializer
puts "whole contains #{whole.content_length} records"
puts "parts contain #{parts.content_length} records"
puts (whole == parts) ? "matchy!" : "no matchy!"
```
