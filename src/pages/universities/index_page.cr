class Universities::IndexPage < MainLayout
  needs universities : UniversityQuery
  quick_def page_title, "All Universities"

  def content
    h1 "所有大学"
    link "新增", New
    render_universities
  end

  def render_universities
    ul do
      universities.each do |university|
        li do
          link university.name, Show.with(university)
        end
      end
    end
  end
end
