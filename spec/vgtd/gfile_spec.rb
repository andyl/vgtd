require 'spec_helper'

describe Gfile do

  context "basic object creation" do
    before(:all) { @obj = Gfile.new }
    specify { expect(@obj).to_not be_nil }
  end

 describe "instance attributes" do
   before(:all) { @obj = Gfile.new }
   specify { expect(@obj).to respond_to(:list)    }
 end

end
