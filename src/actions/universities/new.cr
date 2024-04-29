class Universities::New < BrowserAction
  get "/universities/new" do
    op = CreateUniversity.new(
      province_code: 110000,
      province_name: "北京市",
      city_code: 110100,
      city_name: "北京市",
      is_985: false,
      is_211: false,
      is_good: false
    )

    html NewPage, operation: op
  end
end
