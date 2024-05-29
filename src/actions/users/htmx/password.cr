class User::Htmx::Password < HtmxAction
  put "/users/:id/password" do
    user = UserQuery.find(params.get(:id))

    p! params.get(:password)
    p! params.get(:confirm_password)

    # SaveUser.update!(user, is_editable: !user.is_editable)

    plain_text "ok"
  end
end
