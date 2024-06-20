class Version::Index < BrowserAction
  include Auth::AllowGuests

  get "/version" do
    plain_text "Deployed version: #{College::DEPLOYED_VERSION}"
  end
end
