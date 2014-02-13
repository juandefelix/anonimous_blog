helpers do
  def first name
    name.split(' ').first
  end

  def current_user
    User.find(session[:user_id])
  end

  def user_exists
    return true if session[:user_id]
    false
  end
end
