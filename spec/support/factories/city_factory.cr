class CityFactory < Avram::Factory
  def initialize
    name sequence("城市")

    before_save do
      id = operation.province_id.value

      if id.nil?
        province = ProvinceFactory.create
      else
        province = ProvinceQuery.find(id)
      end

      province_id province.id
    end
  end
end
