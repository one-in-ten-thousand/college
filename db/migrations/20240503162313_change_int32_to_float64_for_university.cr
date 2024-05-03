class ChangeInt32ToFloat64ForUniversity::V20240503162313 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(University), :ranking_2023_min, if_exists: true
    drop_index table_for(University), :ranking_2022_min, if_exists: true
    drop_index table_for(University), :ranking_2021_min, if_exists: true
    drop_index table_for(University), :ranking_2020_min, if_exists: true

    alter table_for(University) do
      change_type ranking_2023_min : Float64, precision: 10, scale: 5
      change_type ranking_2022_min : Float64, precision: 10, scale: 5
      change_type ranking_2021_min : Float64, precision: 10, scale: 5
      change_type ranking_2020_min : Float64, precision: 10, scale: 5
    end

    create_index table_for(University), :ranking_2023_min
    create_index table_for(University), :ranking_2022_min
    create_index table_for(University), :ranking_2021_min
    create_index table_for(University), :ranking_2020_min
  end

  def rollback
    # drop table_for(Thing)
  end
end
