module ApplicationHelper
  def user_signed_in?
     if @current_user
     return true
     end
  end

  def is_admin?
    if @current_user.hierarchy == 2
      return true
    else
      return false
    end
  end
end
