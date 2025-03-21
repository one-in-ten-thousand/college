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
      li do
        span "总数: #{@pages.item_count}", class: "valign-wrapper"
      end
      div class: "col m1" do
        img id: "spinner", class: "htmx-indicator", src: asset("images/spinning-circles.svg"), style: "max-width: 30px;"
      end
    end
  end

  def material_icon(name, link)
    li class: "waves-effect" do
      i(
        class: "material-icons",
        "hx-get": link || "#!",
        "hx-push-url": "true",
        "hx-target": "#main",
        "hx-select": "#main",
        "hx-swap": "outerHTML",
        id: "page_number",
        "hx-indicator": "#spinner"
      ) do
        text name
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
      a(
        page.number,
        href: page.path,
        "hx-get": page.path,
        "hx-push-url": true,
        "hx-target": "#main",
        "hx-select": "#main",
        "hx-swap": "outerHTML",
        id: "page_number",
        "hx-indicator": "#spinner"
      )
    end
  end

  def render_page_item(page : Lucky::Paginator::CurrentPage)
    li class: "active", style: "color: white; width: 2em; height: 1.5em;" do
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
