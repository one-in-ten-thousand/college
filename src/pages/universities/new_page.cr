class Universities::NewPage < MainLayout
  needs operation : SaveUniversity
  quick_def page_title, "新增学校"

  def content
    h1 "新学校"

    form_for Create do
      mount FormFields, operation

      submit "保存", data_disable_with: "保存中..."
    end
  end
end
