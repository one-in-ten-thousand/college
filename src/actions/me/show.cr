class Me::Show < BrowserAction
  get "/me" do
    users = UserQuery.new.id.desc_order

    if current_user.email != "zw963@163.com"
      users = users.id(current_user.id)
    end


    html ShowPage, users: users
  end
end
