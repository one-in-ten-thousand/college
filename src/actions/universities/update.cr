class Universities::Update < BrowserAction
  put "/universities/:university_id" do
    university = UniversityQuery.find(university_id)

    SaveUniversity.update(university, params) do |operation, updated_university|
      if operation.saved?
        if request.headers["HX-Trigger"]? == "update_score_input"
          param_value = params.nested?(:university).to_a[0]
          html(
            Htmx::UpdatedScoreInputPage,
            id: university.id.to_s,
            column_name: param_value[0],
            column_value: param_value[1],
            action: "/htmx/v1/universities/render_update_score_input"
          )
        else
          flash.success = "修改成功"
          redirect Edit.with(updated_university.id)
        end
      else
        flash.failure = "出错了"
        html EditPage, operation: operation, university: updated_university
      end
    end
  end
end
