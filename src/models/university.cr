class University < BaseModel
  table do
    belongs_to province : Province
    belongs_to city : City
  end
end
