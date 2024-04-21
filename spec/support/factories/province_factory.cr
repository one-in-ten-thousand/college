class ProvinceFactory < Avram::Factory
  def initialize
    name sequence("省份")
  end
end
