class Universities::New < BrowserAction
  get "/universities/new" do
    if current_user.is_editable
      user_id = current_user.id.not_nil!

      op = SaveUniversity.new(
        province_code: 110000,
        province_name: "北京市",
        city_code: 110100,
        city_name: "北京市",
        is_985: false,
        is_211: false,
        is_good: false,
        current_user_id: user_id
      )

      html NewPage, operation: op
    else
      flash.failure = "当前用户不允许新增学校"
      redirect Index
    end
  end
end
