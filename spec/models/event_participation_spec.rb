require 'spec_helper'

describe EventParticipation do
  it { should validate_uniqueness_of(:user_id).scoped_to(:event_id) }
end
