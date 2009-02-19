module OpinionsHelper
  def is_owner?
      @current_user == @opinion.user
  end
  
end
