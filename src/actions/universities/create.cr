class Universities::Create < BrowserAction
  post "/universities" do
    CreateUniversity.create(params) do |operation, university|
      if university
        flash.success = "创建成功"
        redirect New
      else
        flash.failure = "出错了"
        html NewPage, operation: operation
      end
    end
  end
end
