class Province < BaseModel
  table do
    column name : String

    has_many universities : University
  end
end
