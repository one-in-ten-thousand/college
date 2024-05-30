class User::Htmx::Editable < HtmxAction
  put "/users/:id/editable" do
    user = UserQuery.find(params.get(:id))

    if current_user.email == "zw963@163.com"
      SaveUser.update!(user, is_editable: !user.is_editable)
    end

    plain_text "ok"
  end
end
