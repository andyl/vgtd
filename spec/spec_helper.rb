ENV["RACK_ENV"] ||= 'test'
require 'rspec'
Dir["lib/**/*.rb"].each {|x| load x}

RSpec.configure do |config|
  config.mock_with :rspec
end

FILE1 = <<-EOF
!x4W =I :P   @co2         |This and that
!afW =T      @co1    #MAB |Do This [more notes go here]
!9ZW =T :B   @co4 -H #MAX |How to move blocks up and down
!d2T =T :B   @co3 -L      |How to promote or demote sections
!TYx =T :B        -M      |Get rid of fold highlighting
!k3T =W :F2  @ema -H #MAD |Get addresses [Dad, Brian Scott]
!TeV =W :F1  @ema -H #MAC |Send honey and cards
=S :FN  @com -L #MAC |Another task
=X :FN  @com -L #MAC |Another task
random text
more random text
does this work?
EOF

FILE2 = <<-EOF
Leading header
Leading header
!x4W =I :P   @co2         |This and that
!afW =T      @co1    *MAB |Do This [more notes go here] /jan23

!9ZW =T :B   @co4 -H *MAX |How to move blocks up and down
!TYx =T :B        -M      |Get rid of fold highlighting
random text
more random text
does this work?
!k3T =W :F2  @ema -H *MAD |Get addresses [Dad, Brian Scott] /mar15
!TeV =W :F1  @ema -H *MAC |Send honey and cards
=S :FN  @com -L *MAC |Another task /dec12
=X :FN  @com -L *MAC |Another task

EOF

TASK_LINE1 = "=T :B @com -H #MAX |How to move blocks up and down"
TASK_LINE2 = "!rE3 =W :FF_vim @ema -H #MAA |Title [Note]"
NORM_LINE1 = "this is a regular text line"

HEADER1 = <<-EOF
This is
header
one
EOF

HEADER2 = "This is header 2"
HEADER3 = ""
