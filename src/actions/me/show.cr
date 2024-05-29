class Me::Show < BrowserAction
  get "/me" do
    users = UserQuery.new.id.desc_order

    html ShowPage, users: users
  end
end
