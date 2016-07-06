def UserHelper < ApplicationHelper
  def your_page?(id)
    return id == current_user.id
  end
end
