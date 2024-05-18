class SignUps::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/sign_up" do
    html SignIns::NewPage, operation: SignInUser.new
  end
end
