class CreateCities::V20240420041900 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(City) do
      primary_key id : Int64
      add name : String, index: true, unique: true
      add code : Int32, index: true, unique: true
      add_belongs_to province : Province, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(City)
  end
end
