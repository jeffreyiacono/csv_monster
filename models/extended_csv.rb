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

  def split split_count
    header, *tail = self.content
    splits = []

    tail.each_with_index do |row, i|
      if (i % tail.length / split_count).zero? && split_count > splits.length
        splits << self.class.new
        splits.last.content << header
      end

      splits.last.content << row
    end

    splits
  end

private

  def default_outfile_name
    "#{Time.now.strftime("%Y%m%d%H%M%S")}_#{@filepaths.length}_files.csv"
  end
end
