class Universities::Htmx::Excluded < HtmxAction
  put "/universities/:university_id/excluded" do
    user_id = current_user.id
    university = UniversityQuery.new.preload_chong_wen_baos.find(university_id)

    chong_wen_bao = ChongWenBaoQuery.new.user_id(user_id).university_id(university.id).first?

    chong_wen_bao = SaveChongWenBao.create!(user_id: user_id, university_id: university.id) if chong_wen_bao.nil?

    SaveChongWenBao.update!(chong_wen_bao, params)

    case request.headers["HX-Trigger"]?
    when "excluded"
      component NameLink, university: university.reload(&.preload_chong_wen_baos), current_user: current_user
    when /unexcluded/
      plain_text ""
    else
      plain_text "ok"
    end
  end
end
