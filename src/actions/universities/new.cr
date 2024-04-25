class Universities::New < BrowserAction
  get "/universities/new" do
    op = SaveUniversity.new(
      province_name: "北京市",
      city_name: "北京市",
      is_985: false,
      is_211: false,
      is_good: false
    )

    html NewPage, operation: op
  end
end
