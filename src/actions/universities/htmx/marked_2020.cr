class Universities::Htmx::Marked2020 < HtmxAction
  put "/universities/:university_id/marked_2020" do
    user_id = current_user.id

    chong_wen_bao = ChongWenBaoQuery.new.user_id(user_id).university_id(university_id).first?

    chong_wen_bao = SaveChongWenBao.create!(user_id: user_id, university_id: university_id.to_i64) if chong_wen_bao.nil?

    SaveChongWenBao.update!(chong_wen_bao, is_marked_2020: !chong_wen_bao.is_marked_2020)

    context.response.headers["HX-Refresh"] = "true"

    plain_text "ok"
  end
end
