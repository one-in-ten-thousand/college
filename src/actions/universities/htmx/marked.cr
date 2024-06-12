class Universities::Htmx::Marked < HtmxAction
  put "/universities/:university_id/marked" do
    user_id = current_user.id.not_nil!
    university = UniversityQuery.new.preload_chong_wen_baos.find(university_id)

    chong_wen_bao = ChongWenBaoQuery.new.user_id(user_id).university_id(university_id).first?

    SaveChongWenBao.update!(chong_wen_bao, is_marked: !chong_wen_bao.is_marked) if chong_wen_bao

    context.response.headers["HX-Refresh"] = "true"

    plain_text "ok"
  end
end
