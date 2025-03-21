class Universities::NewPage < MainLayout
  needs operation : SaveUniversity
  quick_def page_title, "新增学校"

  def content
    br
    br

    link "返回大学列表", Index

    br

    h3 "新学校"

    br

    form_for Create do
      mount FormFields, operation, current_user

      submit "保存", data_disable_with: "保存中..."
    end
  end
end
