class Me::ClearBao < BrowserAction
  put "/me/clear_bao" do
    chong_wen_baos = ChongWenBaoQuery.new.user_id(current_user.id)
      .update(
        bao_2023: false,
        bao_2022: false,
        bao_2021: false,
        bao_2020: false
      )
    plain_text "ok"
  end
end
