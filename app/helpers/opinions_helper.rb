module OpinionsHelper
  def is_owner?
      @current_user == @opinion.user
  end
  def is_admin
    current_user.admin?
  end
end
