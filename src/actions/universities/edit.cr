class Universities::Edit < BrowserAction
  get "/universities/:university_id/edit" do
    user_id = current_user.id.not_nil!
    university = UniversityQuery.new
      .preload_province
      .preload_city
      .preload_chong_wen_baos
      .find(university_id)

    chong_wen_bao = ChongWenBaoQuery.new.university_id(university.id).user_id(user_id).first?

    if chong_wen_bao.nil?
      chong_wen_bao = SaveChongWenBao.create!(user_id: user_id, university_id: university.id)
    end

    op = SaveUniversity.new(
      university,
      province_name: university.province.name,
      province_code: university.province.code,
      city_name: university.city.name,
      city_code: university.city.code,
      chong_2023: chong_wen_bao.chong_2023,
      chong_2022: chong_wen_bao.chong_2022,
      chong_2021: chong_wen_bao.chong_2021,
      chong_2020: chong_wen_bao.chong_2020,
      wen_2023: chong_wen_bao.wen_2023,
      wen_2022: chong_wen_bao.wen_2022,
      wen_2021: chong_wen_bao.wen_2021,
      wen_2020: chong_wen_bao.wen_2020,
      bao_2023: chong_wen_bao.bao_2023,
      bao_2022: chong_wen_bao.bao_2022,
      bao_2021: chong_wen_bao.bao_2021,
      bao_2020: chong_wen_bao.bao_2020,
      current_user_id: user_id,
      university_remark: university.remark(current_user)
    )

    html EditPage, operation: op, university: university
  end
end
