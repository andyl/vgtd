require 'spec_helper'

describe Gblock do

  context "basic object creation" do
    before(:all) { @obj = Gblock.new }
    specify { expect(@obj).to_not be_nil }
  end

  describe "instance attributes" do
    before(:all) { @obj = Gblock.new }
    specify { expect(@obj).to respond_to(:text)   }
    specify { expect(@obj).to respond_to(:tasks)  }
    specify { expect(@obj).to respond_to(:filter)  }
  end

  describe "instance methods" do
    before(:all) { @obj = Gblock.new }
    specify { expect(@obj).to respond_to(:output) }
  end

  describe "#initialize" do
    context "without an input string" do
      before(:each) { @obj = Gblock.new }
      specify { expect(@obj).to_not be_nil }
      specify { expect(@obj.text).to eq ""}
      specify { expect(@obj.tasks).to eq [] }
      specify { expect(@obj.filter).to eq "" }
    end
    context "with an input string" do
      before(:each) { @obj = Gblock.new(HEADER1)                }
      specify { expect(@obj).to_not be_nil }
      specify { expect(@obj.text.lines.count).to eq HEADER1.lines.count}
      specify { expect(@obj.tasks).to eq [] }
      specify { expect(@obj.filter).to eq "" }
    end
  end

  describe "#output" do
    before(:each) { @obj = Gblock.new(HEADER1) }
    specify { expect(@obj.output).to_not be_nil                       }
    specify { expect(@obj.output.class).to       eq String            }
    specify { expect(@obj.output.lines.count).to eq @obj.text.lines.count + @obj.tasks.length }
  end

end
