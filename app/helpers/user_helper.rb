module UserHelper
  def my_profile?(user)
    user == current_user
  end
end
