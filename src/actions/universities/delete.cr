class Universities::Delete < BrowserAction
  delete "/universities/:university_id" do
    if current_user.email == "zw963@163.com"
      university = UniversityQuery.find(university_id)
      DeleteUniversity.delete(university) do |_operation, _deleted|
        flash.success = "删除成功"
        redirect Index
      end
    else
      plain_text "不被允许的"
    end
  end
end
