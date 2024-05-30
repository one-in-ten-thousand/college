class User::Htmx::Password < HtmxAction
  put "/users/:id/password" do
    user = UserQuery.find(params.get(:id))
    SaveUser.update!(user, password: params.get(:password))

    plain_text "ok"
  end
end
