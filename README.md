# CSVMonster

```ruby
require './lib/csv_monster'

first  = CSVMonster.new 'first.csv'
second = CSVMonster.new 'second.csv'
parts  = CSVMonster.new ['first.csv', 'second.csv']
whole  = CSVMonster.new 'first_and_second_already_combined.csv'

# using the + operator
puts (whole == (first + second)) ? "matchy!" : "no matchy!"

# using the initializer
puts "whole contains #{whole.content_length} records"
puts "parts contain #{parts.content_length} records"
puts whole == parts ? "matchy!" : "no matchy!"
```
