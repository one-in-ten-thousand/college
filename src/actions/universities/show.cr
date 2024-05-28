class Universities::Show < BrowserAction
  get "/universities/:university_id" do
    university = UniversityQuery.new
      .preload_province
      .preload_city
      .preload_chong_wen_baos(ChongWenBaoQuery.new.user_id(current_user.id))
      .find(university_id)

    user_chong_wen_bao = university.chong_wen_baos.first?

    html(
      ShowPage,
      university: university,
      user_chong_wen_bao: user_chong_wen_bao
    )
  end
end
