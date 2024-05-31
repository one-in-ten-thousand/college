class User::Htmx::Create < HtmxAction
  post "/users/create" do
    if current_user.email == "zw963@163.com"
      SignUpUser.create!(params)
    end

    redirect Me::Show
  end
end
