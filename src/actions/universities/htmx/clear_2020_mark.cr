class Universities::Htmx::Clear2020Mark < HtmxAction
  put "/universities/clear_2020_mark" do
    chong_wen_baos = ChongWenBaoQuery.new.user_id(current_user.id.not_nil!)

    chong_wen_baos.update(is_marked_2020: false) if chong_wen_baos

    context.response.headers["HX-Refresh"] = "true"

    plain_text "ok"
  end
end
