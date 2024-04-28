class PaginationLinks < Lucky::BaseComponent
  needs pages : Lucky::Paginator

  def render
    # nav aria_label: "pagination", role: "navigation" do
    ul class: "pagination" do
      material_icon("chevron_left", @pages.path_to_previous)
      # previous_link
      page_links
      # next_link
      material_icon("chevron_right", @pages.path_to_next)
    end
    # end
  end

  def material_icon(name, link)
    li class: "waves-effect" do
      a herf: link || "#!" do
        i class: "material-icons" do
          text name
        end
      end
    end
  end

  def page_links
    @pages.series(begin: 1, left_of_current: 1, right_of_current: 1, end: 1).each do |item|
      render_page_item(item)
    end
  end

  def render_page_item(page : Lucky::Paginator::Page)
    li class: "waves-effect" do
      a page.number, href: page.path
    end
  end

  def render_page_item(page : Lucky::Paginator::CurrentPage)
    li class: "waves-effect" do
      text page.number
    end
  end

  def render_page_item(gap : Lucky::Paginator::Gap)
    li "..."
  end

  # def previous_link
  #   if prev_path = @pages.path_to_previous
  #     li class: "waves-effect" { a "前一页", href: prev_path }
  #   end
  # end

  # def next_link
  #   if path_to_next = @pages.path_to_next
  #     li class: "waves-effect" { a "下一页", href: path_to_next }
  #   end
  # end
end
