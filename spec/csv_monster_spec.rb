require './lib/csv_monster'

def sample_csv_filepath
  File.expand_path(File.join("..", "support", "sample.csv"), __FILE__)
end

def another_sample_csv_filepath
  File.expand_path(File.join("..", "support", "another_sample.csv"), __FILE__)
end

def odd_number_of_records_csv_filepath
  File.expand_path(File.join("..", "support", "odd_number_of_records.csv"), __FILE__)
end

def safely_rm file
  FileUtils.rm file if File.exists? file
end

describe CSVMonster do
  describe "#+" do
    let(:csv_monster)         { described_class.new sample_csv_filepath }
    let(:another_csv_monster) { described_class.new another_sample_csv_filepath }

    subject { csv_monster +  another_csv_monster }

    it "yields a new instance with the combination of the two's content" do
      expect(csv_monster.content).to eq [["header_1", "header_2"],
                                          ["row_1_column_1_entry", "row_1_column_2_entry"],
                                          ["row_2_column_1_entry", "row_2_column_2_entry"]]

      expect(another_csv_monster.content).to eq [["header_1", "header_2"],
                                                  ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                                  ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]

      result = subject

      expect(csv_monster.content).to eq [["header_1", "header_2"],
                                          ["row_1_column_1_entry", "row_1_column_2_entry"],
                                          ["row_2_column_1_entry", "row_2_column_2_entry"]]

      expect(another_csv_monster.content).to eq [["header_1", "header_2"],
                                                  ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                                  ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]

      expect(result.content).to eq [["header_1", "header_2"],
                                    ["row_1_column_1_entry", "row_1_column_2_entry"],
                                    ["row_2_column_1_entry", "row_2_column_2_entry"],
                                    ["row_1_column_1_entry_diff_content", "row_1_column_2_entry_diff_content"],
                                    ["row_2_column_1_entry_diff_content", "row_2_column_2_entry_diff_content"]]
    end
  end

  describe "#==" do
    let(:csv_monster)         { described_class.new }
    let(:another_csv_monster) { described_class.new }

    context "when the content is the same" do
      before do
        csv_monster.filepaths         = sample_csv_filepath
        another_csv_monster.filepaths = sample_csv_filepath
      end

      subject { csv_monster == another_csv_monster }
      it      { expect(subject).to be_true }
    end

    context "when the content is different" do
      before do
        csv_monster.filepaths         = sample_csv_filepath
        another_csv_monster.filepaths = another_sample_csv_filepath
      end

      subject { csv_monster == another_csv_monster }
      it      { expect(subject).to be_false }
    end
  end

  describe "#content" do
    let(:csv_monster) { described_class.new }

    context "with a single csv file" do
      before  { csv_monster.filepaths = sample_csv_filepath }
      subject { csv_monster.content }
      it      { expect(subject).to eq [["header_1", "header_2"],
                                       ["row_1_column_1_entry", "row_1_column_2_entry"],
                                       ["row_2_column_1_entry", "row_2_column_2_entry"]] }
    end

    context "with multiple csv files" do
      before  { csv_monster.filepaths = [sample_csv_filepath, another_sample_csv_filepath] }
      subject { csv_monster.content }

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
    let(:csv_monster) { described_class.new sample_csv_filepath }
    subject            { csv_monster.content_length }

    it "equals the number of entries" do
      expect(subject).to eq 3
    end
  end

  describe "#split" do
    let(:number_of_splits) { 2 }

    context "with an even number of records (excluding header)" do
      let(:csv_monster) { described_class.new sample_csv_filepath }

      subject { csv_monster.split(number_of_splits) }

      it "leaves the original instance unchanged" do
        expect(csv_monster.content).to eq [["header_1", "header_2"],
                                            ["row_1_column_1_entry", "row_1_column_2_entry"],
                                            ["row_2_column_1_entry", "row_2_column_2_entry"]]

        subject

        expect(csv_monster.content).to eq [["header_1", "header_2"],
                                            ["row_1_column_1_entry", "row_1_column_2_entry"],
                                            ["row_2_column_1_entry", "row_2_column_2_entry"]]
      end

      it "returns the specified number of objects of the same type" do
        result = subject

        expect(result.length).to eq number_of_splits

        expect(result[0]).to be_an_instance_of described_class
        expect(result[1]).to be_an_instance_of described_class
      end


      it "splits the content amongst the parts evenly" do
        result = subject

        expect(result[0].content).to eq [["header_1", "header_2"],
                                         ["row_1_column_1_entry", "row_1_column_2_entry"]]

        expect(result[1].content).to eq [["header_1", "header_2"],
                                         ["row_2_column_1_entry", "row_2_column_2_entry"]]
      end
    end

    context "with an odd number of records (excluding header)" do
      let(:csv_monster) { described_class.new odd_number_of_records_csv_filepath }

      subject { csv_monster.split(number_of_splits) }

      it "leaves the original instance unchanged" do
        expect(csv_monster.content).to eq [["header_1", "header_2"],
                                            ["odd_row_1_column_1_entry", "odd_row_1_column_2_entry"],
                                            ["odd_row_2_column_1_entry", "odd_row_2_column_2_entry"],
                                            ["odd_row_3_column_1_entry", "odd_row_3_column_2_entry"]]

        subject

        expect(csv_monster.content).to eq [["header_1", "header_2"],
                                            ["odd_row_1_column_1_entry", "odd_row_1_column_2_entry"],
                                            ["odd_row_2_column_1_entry", "odd_row_2_column_2_entry"],
                                            ["odd_row_3_column_1_entry", "odd_row_3_column_2_entry"]]
      end

      it "returns the specified number of objects of the same type" do
        result = subject
        expect(result.length).to eq number_of_splits
        expect(result[0]).to be_an_instance_of described_class
        expect(result[1]).to be_an_instance_of described_class
      end

      it "splits the content amongst the parts approximately evenly" do
        result = subject

        expect(result[0].content).to eq [["header_1", "header_2"],
                                         ["odd_row_1_column_1_entry", "odd_row_1_column_2_entry"]]

        expect(result[1].content).to eq [["header_1", "header_2"],
                                         ["odd_row_2_column_1_entry", "odd_row_2_column_2_entry"],
                                         ["odd_row_3_column_1_entry", "odd_row_3_column_2_entry"]]
      end
    end
  end

  describe "#write!" do
    let(:infile)       { sample_csv_filepath }
    let(:outfile)      { File.expand_path(File.join("..", "support", "test", "write_sample.csv"), __FILE__) }
    let(:csv_monster) { described_class.new infile }

    before  { safely_rm outfile }
    after   { safely_rm outfile }

    subject { csv_monster.write! outfile }

    it "writes the file to the specified location" do
      expect(File.exists? outfile).to be_false
      subject
      expect(FileUtils.identical? infile, outfile).to be_true
    end
  end
end
