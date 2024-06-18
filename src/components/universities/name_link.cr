class Universities::NameLink < BaseComponent
  needs university : University
  needs current_user : User

  def render
    id = "university-#{university.id}"
    name = university.name

    if university.is_985
      name = "#{name}/985"
    elsif university.is_211
      name = "#{name}/211"
    elsif university.is_good
      name = "#{name}/双一流"
    end

    a(
      name,
      href: "#",
      class: "dropdown-trigger",
      data_target: "dropdown3",
      id: id,
      marked_2023: university.marked_2023(current_user),
      marked_2022: university.marked_2022(current_user),
      marked_2021: university.marked_2021(current_user),
      marked_2020: university.marked_2020(current_user),
      marked: university.marked(current_user),
      excluded: university.excluded(current_user),
      script: "on click set @href of <ul#dropdown3 li a/> to '#{Edit.with(university).path}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_marked']/> to '#{Universities::Htmx::Marked.with(university.id).path}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_marked']/> to '##{id}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_marked_2023']/> to '##{id}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_marked_2022']/> to '##{id}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_marked_2021']/> to '##{id}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_marked_2020']/> to '##{id}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_marked_2023']/> to '#{Universities::Htmx::Marked2023.with(university.id).path}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_marked_2022']/> to '#{Universities::Htmx::Marked2022.with(university.id).path}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_marked_2021']/> to '#{Universities::Htmx::Marked2021.with(university.id).path}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_marked_2020']/> to '#{Universities::Htmx::Marked2020.with(university.id).path}'
then set @hx-put of <ul#dropdown3 li input[name='university:is_excluded']/> to '#{Universities::Htmx::Excluded.with(university.id).path}'
then set @hx-target of <ul#dropdown3 li input[name='university:is_excluded']/> to '##{id}'
then js htmx.process(document.body) end
then if @marked-2023 as String == 'true'
  js document.getElementById('marked_2023').checked = true; end
else
  js document.getElementById('marked_2023').checked = false; end
end
then if @marked-2022 as String == 'true'
  js document.getElementById('marked_2022').checked = true; end
else
  js document.getElementById('marked_2022').checked = false; end
end
then if @marked-2021 as String == 'true'
  js document.getElementById('marked_2021').checked = true; end
else
  js document.getElementById('marked_2021').checked = false; end
end
then if @marked-2020 as String == 'true'
  js document.getElementById('marked_2020').checked = true; end
else
  js document.getElementById('marked_2020').checked = false; end
end
then if @marked as String == 'true'
  js document.getElementById('marked').checked = true; end
else
  js document.getElementById('marked').checked = false; end
end
then if @excluded as String == 'true'
  js document.getElementById('excluded').checked = true; end
else
  js document.getElementById('excluded').checked = false; end
end
"
    )
  end
end
