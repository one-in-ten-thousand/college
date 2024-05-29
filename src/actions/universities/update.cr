class Universities::Update < BrowserAction
  include PageHelpers

  put "/universities/:university_id" do
    university = UniversityQuery.find(university_id)

    SaveUniversity.update(university, params) do |operation, updated_university|
      if operation.saved?
        hx_trigger = request.headers["HX-Trigger"]?
        if hx_trigger == "update_score_input"
          param_value = params.nested?(:university).to_a[0]
          column_name = param_value[0]
          column_value = param_value[1]

          component(
            ClickEditTD,
            id: university.id.to_s,
            column_name: column_name,
            column_value: column_value,
            action: "/htmx/v1/universities/render_update_score_input",
            tooltip: show_ranking_number(column_value),
            current_user: current_user
          )
        elsif hx_trigger.in? [
                "chong_2023", "chong_2022", "chong_2021", "chong_2020",
                "wen_2023", "wen_2022", "wen_2021", "wen_2020",
                "bao_2023", "bao_2022", "bao_2021", "bao_2020",
              ]
          # 此时，hx-swap 是 none, 啥也不替换，因为 checkbox 状态 click 的时候已经变了
          plain_text "ok"
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
