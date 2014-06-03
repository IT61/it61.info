require 'spec_helper'

describe Event do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:organizer) }
  it { should validate_presence_of(:place) }
end
