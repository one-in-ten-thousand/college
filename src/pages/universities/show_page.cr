class Universities::ShowPage < MainLayout
  needs university : University
  quick_def page_title, "University with id: #{university.id}"

  def content
    link "Back to all Universities", Index
    h1 "University with id: #{university.id}"
    render_actions
    render_university_fields
  end

  def render_actions
    section do
      link "编辑", Edit.with(university.id)
      text " | "
      link(
        "删除",
        Delete.with(university.id),
        "hx-target": "body",
        "hx-confirm": "确定删除吗?",
        "hx-push-url": "true",
        "hx-delete": Delete.with(university.id).path,
        "hx-include": "next input"
      )
      input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
    end
  end

  def render_university_fields
    ul do
      li do
        text "text: "
        strong university.name.to_s
      end
    end
  end
end
