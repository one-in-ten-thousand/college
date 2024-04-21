class UniversityFactory < Avram::Factory
  def initialize
    name sequence("大学")

    before_save do
      while code = rand(1000..9999)
        break unless UniversityQuery.new.code(code).first?
      end

      id = operation.city_id.value

      if id.nil?
        city = CityFactory.create
      else
        city = CityQuery.find(id)
      end

      city_id city.id
      province_id city.province.id
      code code
    end
  end
end
