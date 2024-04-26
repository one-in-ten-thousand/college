class University < BaseModel
  table do
    column name : String
    column description : String?
    column code : Int32?
    column batch_number : String?
    column is_211 : Bool
    column is_985 : Bool
    column is_good : Bool

    # column score_2023_max : Int32?
    # column ranking_2023_max : Int32?

    column score_2023_min : Int32?
    column ranking_2023_min : Int32?

    belongs_to province : Province
    belongs_to city : City
  end
end
