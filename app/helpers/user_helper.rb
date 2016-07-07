module UserHelper
  def your_profile?(user)
    user == current_user
    true
  end
end
