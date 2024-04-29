class RemoveRankingScoreIndexFromUniversity::V20240429150747 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(University), :score_2023_max, if_exists: true
    drop_index table_for(University), :score_2023_min, if_exists: true
    drop_index table_for(University), :score_2022_max, if_exists: true
    drop_index table_for(University), :score_2022_min, if_exists: true
    drop_index table_for(University), :score_2021_max, if_exists: true
    drop_index table_for(University), :score_2021_min, if_exists: true
    drop_index table_for(University), :score_2020_max, if_exists: true
    drop_index table_for(University), :score_2020_min, if_exists: true

    drop_index table_for(University), :ranking_2023_max, if_exists: true
    drop_index table_for(University), :ranking_2023_min, if_exists: true
    drop_index table_for(University), :ranking_2022_max, if_exists: true
    drop_index table_for(University), :ranking_2022_min, if_exists: true
    drop_index table_for(University), :ranking_2021_max, if_exists: true
    drop_index table_for(University), :ranking_2021_min, if_exists: true
    drop_index table_for(University), :ranking_2020_max, if_exists: true
    drop_index table_for(University), :ranking_2020_min, if_exists: true
  end

  def rollback
    # drop table_for(Thing)
  end
end
