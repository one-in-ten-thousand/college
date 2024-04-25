class Universities::EditPage < MainLayout
  needs operation : SaveUniversity

  quick_def page_title, "编辑 #{operation.name.value}"

  def content
    link "Back to all Universities", Index

    form_for Update.with(operation.id.value.as(Int64)) do
      mount FormFields, operation

      submit "更新", data_disable_with: "更新中..."
    end
  end
end
