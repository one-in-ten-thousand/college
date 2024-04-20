class Province < BaseModel
  table do
    has_many universities : University
  end
end
