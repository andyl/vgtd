require 'spec_helper'

describe Gtask do

  context "basic object creation" do
    before(:all) { @obj = Gtask.new }
    specify { expect(@obj).to_not be_nil }
  end

  describe "instance attributes" do
    before(:all) { @obj = Gtask.new }
    specify { expect(@obj).to respond_to(:handle)   }
    specify { expect(@obj).to respond_to(:category) }
    specify { expect(@obj).to respond_to(:project)  }
    specify { expect(@obj).to respond_to(:context)  }
    specify { expect(@obj).to respond_to(:priority) }
    specify { expect(@obj).to respond_to(:contact)  }
    specify { expect(@obj).to respond_to(:task)     }
    specify { expect(@obj).to respond_to(:note)     }
  end

  describe "instance methods" do
    before(:all) { @obj = Gtask.new }
    specify { expect(@obj).to respond_to(:output)        }
    specify { expect(@obj).to respond_to(:category_rank) }
    specify { expect(@obj).to respond_to(:priority_rank) }
    specify { expect(@obj).to respond_to(:valid_input?)  }
  end

  describe "#initialize" do
    context "without an input string" do
      before(:each) { @obj = Gtask.new }
      specify { expect(@obj).to_not be_nil }
      specify { expect(@obj.category).to eq "=I" }
      specify { expect(@obj.project).to  eq "" }
    end
    context "with an input string" do
      before(:each) { @obj = Gtask.new(TASK_LINE2) }
      specify { expect(@obj.handle).to   eq "!rE3"     }
      specify { expect(@obj.category).to eq "=W"       }
      specify { expect(@obj.project).to  eq ":FF_vim"  }
      specify { expect(@obj.context).to  eq "@ema"     }
      specify { expect(@obj.priority).to eq "-H"       }
      specify { expect(@obj.contact).to  eq "#MAA"     }
      specify { expect(@obj.task).to     eq "|Title"   }
      specify { expect(@obj.note).to     eq "[Note]"   }
    end
  end

  describe "#category_rank" do
    before(:each) { @obj = Gtask.new }
    specify { @obj.category = "=I"; expect(@obj.category_rank).to eq 1 }
    specify { @obj.category = "=A"; expect(@obj.category_rank).to eq 2 }
    specify { @obj.category = "=W"; expect(@obj.category_rank).to eq 3 }
    specify { @obj.category = "=T"; expect(@obj.category_rank).to eq 4 }
    specify { @obj.category = "=S"; expect(@obj.category_rank).to eq 5 }
    specify { @obj.category = "=R"; expect(@obj.category_rank).to eq 6 }
    specify { @obj.category = "=X"; expect(@obj.category_rank).to eq 7 }
    specify {                       expect(@obj.category_rank).to eq 1 }
  end

  describe "#priority_rank" do
    before(:each) { @obj = Gtask.new }
    specify { @obj.priority = "-H"; expect(@obj.priority_rank).to eq 1 }
    specify { @obj.priority = "-M"; expect(@obj.priority_rank).to eq 2 }
    specify { @obj.priority = "-L"; expect(@obj.priority_rank).to eq 3 }
    specify { @obj.priority = "-X"; expect(@obj.priority_rank).to eq 4 }
    specify {                       expect(@obj.priority_rank).to eq 4 }
  end

  describe "#output" do
    context "using valid input" do
      context "without a handle" do
        before(:each) { @obj = Gtask.new(TASK_LINE1) }
        specify { expect(@obj.output.class).to eq String }
      end
      context "with a handle" do
        before(:each) { @obj = Gtask.new(TASK_LINE2) }
        specify { expect(@obj.output[0]).to eq "!"[0]    }
        specify { expect(@obj.output.class).to eq String }
      end
    end
    context "using invalid input" do
      context "(empty string)" do
        before(:each) { @obj = Gtask.new("") }
        specify { expect(@obj.output[0]).to_not eq "!"[0] }
        specify { expect(@obj.output.class).to eq String  }
        specify { expect(@obj.output.length).to eq 2      }
      end
      context "(random string)" do
        before(:each) { @obj = Gtask.new("|test")    }
        specify { expect(@obj.output).to eq "=I |test"   }
        specify { expect(@obj.output.class).to eq String }
      end
    end
  end

  describe "#setup_date" do
    before(:each) { @obj = Gtask.new(TASK_LINE1) }
    it "it).to calculate a fixed date" do
      @obj.setup_date("/jan22")
      expect(@obj.date).to eq "/jan22"
    end
    it "it).to calculate today's date" do
      @obj.setup_date("Time.now")
      expect(@obj.date).to eq "/" + Time.now.strftime("%b%d").downcase
    end
    it "it).to handle nil date" do
      @obj.setup_date
      expect(@obj.date).to eq ""
    end
    it "it).to handle future dates (weeks)" do
      require 'active_support/core_ext'
      @obj.setup_date("2.weeks.from_now")
      expect(@obj.date).to eq "/" + 2.weeks.from_now.strftime("%b%d").downcase
    end
    it "it).to handle future dates (months)" do
      require 'active_support/core_ext'
      @obj.setup_date("2.months.from_now")
      expect(@obj.date).to eq "/" + 2.months.from_now.strftime("%b%d").downcase
    end
    it "it).to handle future dates (years)" do
      require 'active_support/core_ext'
      @obj.setup_date("2.years.from_now")
      expect(@obj.date).to eq "/" + 2.years.from_now.strftime("%b%d").downcase
    end
  end

end
