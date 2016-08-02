module UsersHelper
  def avatar_for user, options = { size: 80 }
    if user.avatar?
      image_tag user.avatar, class: "my-avatar-home"
    else
      image_tag "medium/missing.png", class: "my-avatar-home"
    end
  end
end
