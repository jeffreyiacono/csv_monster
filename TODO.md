# TODO

### add split method
Add in a #split method that takes an integer and splits its content into that
many equal parts and writes each.

Example:

```ruby
e = ExtendedCSV.new 'somefile.csv' # 1 header + 20 rows
e.split(4)
#=> wrote 4 different files:
#     - somefile_1.csv # 1 header + 5 rows
#     - somefile_2.csv # 1 header + 5 rows
#     - somefile_3.csv # 1 header + 5 rows
#     - somefile_4.csv # 1 header + 5 rows
```
