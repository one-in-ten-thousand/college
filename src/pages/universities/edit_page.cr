class Universities::EditPage < MainLayout
  needs operation : SaveUniversity
  needs university : University

  quick_def page_title, "编辑 #{university.name}"

  def content
    link "Back to all Universities", Index

    form_for Update.with(university.id) do
      mount FormFields, operation

      submit "更新", data_disable_with: "更新中..."
    end
  end
end
