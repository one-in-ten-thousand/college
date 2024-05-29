class User::Htmx::Editable < HtmxAction
  put "/users/:id/editable" do
    user = UserQuery.find(params.get(:id))

    SaveUser.update!(user, is_editable: !user.is_editable)

    plain_text "ok"
  end
end
