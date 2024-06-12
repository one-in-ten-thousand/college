class Universities::NameLink < BaseComponent
  needs university : University
  needs current_user : User

  def render
    a(
      university.name,
      href: "#",
      class: "dropdown-trigger",
      data_target: "dropdown3",
      marked: university.marked(current_user),
      script: "on click set @href of <ul#dropdown3 li a[href='data_edit_url']/> to '#{Edit.with(university).path}'
then set @hx-put of <ul#dropdown3 li input[hx-put='data_marked_url']/> to '#{Universities::Htmx::Marked.with(university.id).path}'
then js htmx.process(document.body) end
then if @marked as String == 'true'
  js document.getElementById('marked').checked = true; end
else
  js document.getElementById('marked').checked = false; end
end
"
    )
  end
end
