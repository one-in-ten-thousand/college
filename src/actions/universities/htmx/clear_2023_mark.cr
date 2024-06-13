class Universities::Htmx::Clear2023Mark < HtmxAction
  put "/universities/clear_2023_mark" do
    chong_wen_baos = ChongWenBaoQuery.new.user_id(current_user.id)

    chong_wen_baos.update(is_marked_2023: false) if chong_wen_baos

    context.response.headers["HX-Refresh"] = "true"

    plain_text "ok"
  end
end
