# frozen_string_literal: true
module UserHelper
  def my_profile?(user)
    user == current_user
  end
end
