class Universities::IndexPage < MainLayout
  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  quick_def page_title, "All Universities"

  def content
    h1 "所有大学"
    link "新增", New
    render_search
    div id: "main" do
      mount PaginationLinks, pages unless pages.one_page?
      render_universities
      mount PaginationLinks, pages unless pages.one_page?
    end
  end

  def render_search
    # form(method: "get", class: "tool-bar", action: Index.path) do
    #   search_input(op.search, attrs: [:required], class: "custom-input")
    # end

    raw <<-'HEREDOC'
<form action="/universities" method="get">
<div class="row">
  <input
id="search"
type="search"
name="q"
class="s12 m8 input-field"
value=""
placeholder="输入大学名称模糊搜索"
hx-get="/universities"
hx-target="#main"
hx-select="#main"
hx-trigger="search, keyup delay:400ms changed"
hx-push-url="true"
/>
  <input type="submit" value="搜索"/>
</div>
</form>
HEREDOC
  end

  def render_universities
    table do
      thead do
        tr do
          th "ID编号"
          th "报考编码"
          th "大学名称(点击名称编辑)"
          th "录取批次"
          th "补充信息"
          th "修改时间"
        end
      end

      tbody do
        universities.each do |university|
          tr do
            td university.id
            td university.code.to_s
            td do
              link university.name, Edit.with(university)
            end
            td university.batch_level.display_name
            td do
              text university.description.to_s
            end
            td university.updated_at.to_s("%m月%d日 %H:%M:%S")
          end
        end
      end
    end
  end
end
