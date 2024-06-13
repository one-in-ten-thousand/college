class Universities::Htmx::Marked < HtmxAction
  put "/universities/:university_id/marked" do
    user_id = current_user.id

    chong_wen_bao = ChongWenBaoQuery.new.user_id(user_id).university_id(university_id).first?

    chong_wen_bao = SaveChongWenBao.create!(user_id: user_id, university_id: university_id.to_i64) if chong_wen_bao.nil?

    SaveChongWenBao.update!(chong_wen_bao, is_marked: !chong_wen_bao.is_marked)

    # context.response.headers["HX-Refresh"] = "true"

    plain_text "ok"
  end
end
