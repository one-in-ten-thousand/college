class Universities::Update < BrowserAction
  include PageHelpers

  put "/universities/:university_id" do
    university = UniversityQuery.find(university_id)

    SaveUniversity.update(university, params) do |operation, updated_university|
      if operation.saved?
        if request.headers["HX-Trigger"]? == "update_score_input"
          param_value = params.nested?(:university).to_a[0]
          column_name = param_value[0]
          column_value = param_value[1]

          component(
            ClickEditTD,
            id: university.id.to_s,
            column_name: column_name,
            column_value: column_value,
            action: "/htmx/v1/universities/render_update_score_input",
            tooltip: show_ranking_number(column_value)
          )
        else
          flash.success = "修改成功, 使用浏览器返回键返回"
          html EditPage, operation: operation, university: updated_university
        end
      else
        flash.failure = "出错了"
        html EditPage, operation: operation, university: updated_university
      end
    end
  end
end
