class Universities::EditPage < MainLayout
  needs operation : CreateUniversity
  needs university : University

  quick_def page_title, "编辑 #{university.name}"

  def content
    br
    br

    link "返回大学列表", Index

    form_for Update.with(university.id) do
      mount FormFields, operation

      submit "更新", data_disable_with: "更新中..."
    end
  end
end
