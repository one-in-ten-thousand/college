class City < BaseModel
  table do
    column name : String

    belongs_to province : Province
    has_many universities : University
  end
end
