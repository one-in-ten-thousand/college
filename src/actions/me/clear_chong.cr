class Me::ClearChong < BrowserAction
  put "/me/clear_chong" do
    ChongWenBaoQuery.new.user_id(current_user.id)
      .update(
      chong_2023: false,
      chong_2022: false,
      chong_2021: false,
      chong_2020: false
    )
    plain_text "ok"
  end
end
