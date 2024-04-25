class Universities::Delete < BrowserAction
  delete "/universities/:university_id" do
    university = UniversityQuery.find(university_id)
    DeleteUniversity.delete(university) do |_operation, _deleted|
      flash.success = "删除成功"
      redirect Index
    end
  end
end
