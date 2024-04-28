class Universities::IndexPage < MainLayout
  needs universities : UniversityQuery
  quick_def page_title, "All Universities"

  def content
    h1 "所有大学"
    link "新增", New
    render_universities
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
            # # link university.name, Show.with(university)
            td university.name.to_s
            td university.batch_level.to_s
          end
        end
      end
    end
  end
end
