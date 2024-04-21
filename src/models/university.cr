class University < BaseModel
  table do
    column name : String
    column code : Int32

    belongs_to province : Province
    belongs_to city : City
  end
end
