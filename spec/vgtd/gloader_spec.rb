require 'spec_helper'

describe Gloader do

  context "basic object creation" do
    before(:all) { @obj = Gloader.new }
    specify { expect(@obj).to_not be_nil }
  end

  context "creating with a text file" do
    before(:all) { @obj = Gloader.new(FILE1) }
    specify { expect(@obj).to_not be_nil }
  end

  context "creating with a text file" do
    before(:all) { @obj = Gloader.new(FILE2) }
    specify { expect(@obj).to_not be_nil }
  end

end
