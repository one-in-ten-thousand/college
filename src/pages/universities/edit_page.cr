class Universities::EditPage < MainLayout
  needs operation : SaveUniversity
  needs university : University

  quick_def page_title, "编辑 #{university.name}"

  def content
    br
    br

    # link "返回大学列表", Index
    link "打开详情", Show.with(university.id)

    br
    br

    form_for Update.with(university.id), "hx-push-url": false do
      mount FormFields, operation, current_user

      submit "更新", data_disable_with: "更新中..."
    end
  end
end
