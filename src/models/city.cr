class City < BaseModel
  table do
    belongs_to province : Province
    has_many universities : University
  end
end
