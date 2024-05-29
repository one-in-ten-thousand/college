class Me::ClearWen < BrowserAction
  put "/me/clear_wen" do
    chong_wen_baos = ChongWenBaoQuery.new.user_id(current_user.id)
      .update(
        wen_2023: false,
        wen_2022: false,
        wen_2021: false,
        wen_2020: false
      )
    plain_text "ok"
  end
end
