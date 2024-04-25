class University < BaseModel
  table do
    column name : String
    column description : String?
    column code : Int32?
    column is_211 : Bool
    column is_985 : Bool
    column is_good : Bool

    belongs_to province : Province
    belongs_to city : City
  end
end
