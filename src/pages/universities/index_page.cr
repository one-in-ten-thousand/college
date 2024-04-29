class Universities::IndexPage < MainLayout
  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  quick_def page_title, "All Universities"

  def content
    h1 "所有大学"
    link "新增", New
    render_search
    mount PaginationLinks, pages unless pages.one_page?
    render_universities
    mount PaginationLinks, pages unless pages.one_page?
  end

  def render_search
    raw <<-'HEREDOC'
<label for="search">搜索</label>
<input placeholder="搜索大学名称" type="search" id="search" name="q" value="value">
<button hx-get="/index" hx-target="#main" hx-include="#search">
  Search the Contacts
</button>
HEREDOC
  end

  def render_universities
    table do
      thead do
        tr do
          th "ID编号"
          th "报考编码"
          th "大学名称"
          th "录取批次"
        end
      end

      tbody do
        universities.each do |university|
          tr do
            td university.id
            td university.code.to_s
            td university.name.to_s
            td university.batch_level.to_s
          end
        end
      end
    end
  end
end
