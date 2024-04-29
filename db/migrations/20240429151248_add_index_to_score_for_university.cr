class AddIndexToScoreForUniversity::V20240429151248 < Avram::Migrator::Migration::V1
  def migrate
    create_index table_for(University), [:score_2023_min]
    create_index table_for(University), [:score_2022_min]
    create_index table_for(University), [:score_2021_min]
    create_index table_for(University), [:score_2020_min]

    create_index table_for(University), [:ranking_2023_min]
    create_index table_for(University), [:ranking_2022_min]
    create_index table_for(University), [:ranking_2021_min]
    create_index table_for(University), [:ranking_2020_min]
  end

  def rollback
    # drop table_for(Thing)
  end
end
