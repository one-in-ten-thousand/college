class City < BaseModel
  table do
    column name : String
    column code : Int32

    belongs_to province : Province
    has_many universities : University
  end
end
