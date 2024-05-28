class ChongWenBao < BaseModel
  table do
    column chong_2023 : Bool = false
    column wen_2023 : Bool = false
    column bao_2023 : Bool = false
    column chong_2022 : Bool = false
    column wen_2022 : Bool = false
    column bao_2022 : Bool = false
    column chong_2021 : Bool = false
    column wen_2021 : Bool = false
    column bao_2021 : Bool = false
    column chong_2020 : Bool = false
    column wen_2020 : Bool = false
    column bao_2020 : Bool = false
    column user_university_remark : String?

    belongs_to user : User
    belongs_to university : University
  end
end
