require 'csv'

class ExtendedCSV
  attr_reader :filepaths

  def initialize filepaths = nil
    self.filepaths = filepaths
  end

  def filepaths= filepaths
    @filepaths = [*filepaths]
  end

  def + other_extended_csv
    self.class.new self.filepaths + other_extended_csv.filepaths
  end

  def content
    return @content if defined? @content

    @content ||= []
    @filepaths.each_with_index do |csv_filepath, i|
      csv = CSV.parse(File.read(csv_filepath))
      csv.shift unless i == 0

      csv.each do |row|
        @content << row
      end
    end

    @content
  end

  def == other_extended_csv
    content == other_extended_csv.content
  end

  def content_length
    content.length
  end

  def write! outfile = nil
    outfile ||= default_outfile_name
    CSV.open(outfile, "wb") do |csv|
      content.each do |row|
        csv << row
      end
    end

    puts "wrote #{@filepaths.length} file#{'s' if @filepaths.length != 1} to #{outfile}"
  end

  def split times_to_split
    records_per_file = (self.content_length - 1) / times_to_split.to_i
    original_content = self.content
    headers = original_content.shift
    split_content = []
    split_content_index = 0
    incrementor=0

    self.content.each do |row|
      incrementor += 1
      if incrementor == 1
        split_content[split_content_index] = ExtendedCSV.new#[]
        split_content[split_content_index].content.push headers
      end

      split_content[split_content_index].content.push row

      if incrementor  == records_per_file
        split_content_index += 1
        incrementor          = 0
      end
    end
    puts split_content
    return split_content
  end

private

  def default_outfile_name
    "#{Time.now.strftime("%Y%m%d%H%M%S")}_#{@filepaths.length}_files.csv"
  end
end
