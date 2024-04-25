class Province < BaseModel
  table do
    column name : String
    column code : Int32

    has_many universities : University
    has_many cities : City
  end
end
