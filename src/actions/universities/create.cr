class Universities::Create < BrowserAction
  post "/universities" do
    SaveUniversity.create(params) do |operation, university|
      if university
        flash.success = "创建成功"
        redirect Show.with(university.id)
      else
        flash.failure = "出错了"
        html NewPage, operation: operation
      end
    end
  end
end
