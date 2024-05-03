class Universities::Htmx::FindCode < HtmxAction
  get "/universities/find_code" do
    code = params.nested(:university)["code"]
    record = UniversityQuery.new.code(code).first?

    if record.nil?
      plain_text ""
    else
      plain_text "#{record.name} 已经存在!"
    end
  end
end
