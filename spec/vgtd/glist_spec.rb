require 'spec_helper'

describe Glist do

  context "basic object creation" do
    before(:all) { @obj = Glist.new }
    specify { expect(@obj).to_not be_nil }
  end

  describe "instance attributes" do
    before(:all) { @obj = Glist.new }
    specify { expect(@obj).to respond_to(:tasks)   }
    specify { expect(@obj).to respond_to(:widths)  }
  end

  describe "instance methods" do
    before(:all) { @obj = Glist.new }
    specify { expect(@obj).to respond_to(:categories)     }
    specify { expect(@obj).to respond_to(:projects)       }
    specify { expect(@obj).to respond_to(:contexts)       }
    specify { expect(@obj).to respond_to(:priorities)     }
    specify { expect(@obj).to respond_to(:contacts)       }
    specify { expect(@obj).to respond_to(:category_tasks) }
    specify { expect(@obj).to respond_to(:project_tasks)  }
    specify { expect(@obj).to respond_to(:context_tasks)  }
    specify { expect(@obj).to respond_to(:priority_tasks) }
    specify { expect(@obj).to respond_to(:contact_tasks)  }
    specify { expect(@obj).to respond_to(:output)         }
    specify { expect(@obj).to respond_to(:sort)           }
  end

  describe "#initialize" do
    context "without an input string" do
      before(:each) { @obj = Glist.new }
      specify { expect(@obj).to_not be_nil }
      specify { expect(@obj.tasks).to eq [] }
    end
    context "with an input string" do
      before(:each) { @obj = Glist.new(FILE1)                 }
      specify { expect(@obj.tasks.length).to eq 9 }
      specify { expect(@obj.tasks.first.class).to eq Gtask        }
    end
  end

  describe "#calc_widths" do
    before(:each) { @obj = Glist.new(FILE1) }
    specify { expect(@obj.widths[:category]).to eq 2 }
    specify { expect(@obj.widths[:project]).to  eq 3 }
    specify { expect(@obj.widths[:contact]).to  eq 4 }
  end

  describe "#output" do
    before(:each) { @obj = Glist.new(FILE1) }
    specify { expect(@obj.output).to_not be_nil                       }
    specify { expect(@obj.output.class).to       eq String            }
    specify { expect(@obj.output.lines.count).to eq 12 }
  end

  describe "#sort" do
    before(:each) { @obj = Glist.new(FILE1) }
    specify { expect(@obj.sort.class).to eq Glist }
    specify { expect(@obj.sort.tasks.length).to eq @obj.tasks.length }
    specify { expect(@obj.sort("context").tasks.length).to  eq @obj.tasks.length }
    specify { expect(@obj.sort("contact").tasks.length).to  eq @obj.tasks.length }
    specify { expect(@obj.sort("project").tasks.length).to  eq @obj.tasks.length }
    specify { expect(@obj.sort("priority").tasks.length).to eq @obj.tasks.length }
    specify { expect(@obj.sort("unknown").tasks.length).to  eq @obj.tasks.length }
    specify { expect(@obj.sort("none").tasks.length).to     eq @obj.tasks.length }
  end

  describe "selector methods" do
    before(:each) { @obj = Glist.new(FILE1) }

    describe "#projects" do
      specify { expect(@obj.projects.class).to  eq Array }
      specify { expect(@obj.projects.length).to eq 5     }
    end

    describe "#contexts" do
      specify { expect(@obj.contexts.class).to  eq Array }
      specify { expect(@obj.contexts.length).to eq 6     }
    end

    describe "#project_tasks" do
      specify { expect(@obj.project_tasks(":B").class).to  eq Array       }
      specify { expect(@obj.project_tasks(":B").first.class).to  eq Gtask }
      specify { expect(@obj.project_tasks(":B").length).to eq 3           }
    end

    describe "#context_tasks" do
      specify { expect(@obj.context_tasks("@ema").class).to  eq Array       }
      specify { expect(@obj.context_tasks("@ema").first.class).to  eq Gtask }
      specify { expect(@obj.context_tasks("@ema").length).to eq 2           }
    end

  end

end
