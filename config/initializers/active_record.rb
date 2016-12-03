ActiveRecord::Base.send(:extend, StringStripper::InclusionMethods)
ActiveRecord::Base.send(:extend, ConcernedWith)
