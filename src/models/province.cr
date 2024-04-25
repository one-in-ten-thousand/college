class Province < BaseModel
  table do
    column name : String

    has_many universities : University
    has_many cities : City
  end
end
