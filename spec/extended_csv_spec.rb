require './models/extended_csv'

def sample_csv_filepath
  File.expand_path(File.join("..", "support", "sample.csv"), __FILE__)
end

def another_sample_csv_filepath
  File.expand_path(File.join("..", "support", "another_sample.csv"), __FILE__)
end

describe ExtendedCSV do
  describe "#==" do
    let(:extended_csv)         { described_class.new }
    let(:another_extended_csv) { described_class.new }

    context "when the content is the same" do
      before do
        extended_csv.filepaths         = sample_csv_filepath
        another_extended_csv.filepaths = sample_csv_filepath
      end

      subject { extended_csv == another_extended_csv }
      it      { expect(subject).to be_true }
    end

    context "when the content is different" do
      before do
        extended_csv.filepaths         = sample_csv_filepath
        another_extended_csv.filepaths = another_sample_csv_filepath
      end

      subject { extended_csv == another_extended_csv }
      it      { expect(subject).to be_false }
    end
  end

  describe "#+" do
    let(:extended_csv)         { described_class.new sample_csv_filepath }
    let(:another_extended_csv) { described_class.new another_sample_csv_filepath }

    subject { extended_csv +  another_extended_csv }

    it "yields a new instance with the combination of the two's content" do
      expect(extended_csv.content).to eq [["header_1", "header_2"],
                                          ["row_1_column_1_entry", "row_1_column_2_entry"],
                                          ["row_2_column_1_entry", "row_2_column_2_entry"]]

      expect(another_extended_csv.content).to eq [["header_1", "header_2"],
                                                  ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                                  ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]

      result = subject

      expect(extended_csv.content).to eq [["header_1", "header_2"],
                                          ["row_1_column_1_entry", "row_1_column_2_entry"],
                                          ["row_2_column_1_entry", "row_2_column_2_entry"]]

      expect(another_extended_csv.content).to eq [["header_1", "header_2"],
                                                  ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                                  ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]

      expect(result.content).to eq [["header_1", "header_2"],
                                    ["row_1_column_1_entry", "row_1_column_2_entry"],
                                    ["row_2_column_1_entry", "row_2_column_2_entry"],
                                    ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                    ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]
    end
  end

  describe "#content" do
    let(:extended_csv) { described_class.new }

    context "with a single csv file" do
      before  { extended_csv.filepaths = sample_csv_filepath }
      subject { extended_csv.content }
      it      { expect(subject).to eq [["header_1", "header_2"],
                                       ["row_1_column_1_entry", "row_1_column_2_entry"],
                                       ["row_2_column_1_entry", "row_2_column_2_entry"]] }
    end

    context "with multiple csv files" do
      before  { extended_csv.filepaths = [sample_csv_filepath, another_sample_csv_filepath] }
      subject { extended_csv.content }

      it "combines the content, removing headers from all but the first" do
        expect(subject).to eq [["header_1", "header_2"],
                               ["row_1_column_1_entry", "row_1_column_2_entry"],
                               ["row_2_column_1_entry", "row_2_column_2_entry"],
                               ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                               ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]
      end
    end
  end

  describe "#content_length" do
    let(:extended_csv) { described_class.new sample_csv_filepath }
    subject            { extended_csv.content_length }

    it "equals the number of entries" do
      expect(subject).to eq 3
    end
  end

  describe "#write!" do
    let(:infile)       { sample_csv_filepath }
    let(:outfile)      { File.expand_path(File.join("..", "support", "test", "write_sample.csv"), __FILE__) }
    let(:extended_csv) { described_class.new infile }

    before  { FileUtils.rm outfile if File.exists? outfile }
    after   { FileUtils.rm outfile }

    subject { extended_csv.write! outfile }

    it "writes the file to the specified location" do
      expect(File.exists? outfile).to be_false
      subject
      expect(FileUtils.identical? infile, outfile).to be_true
    end
  end
end
