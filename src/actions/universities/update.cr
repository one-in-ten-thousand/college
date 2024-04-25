class Universities::Update < BrowserAction
  put "/universities/:university_id" do
    university = UniversityQuery.find(university_id)
    SaveUniversity.update(university, params) do |operation, updated_university|
      if operation.saved?
        flash.success = "修改成功"
        redirect Show.with(updated_university.id)
      else
        flash.failure = "出错了"
        html EditPage, operation: operation
      end
    end
  end
end
