module UserHelper
  def your_profile?(user)
    user == current_user
  end
end
