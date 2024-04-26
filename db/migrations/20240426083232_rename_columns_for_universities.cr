class RenameColumnsForUniversities::V20240426083232 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      rename :ranking_2023_mix, :ranking_2023_min
      rename :ranking_2022_mix, :ranking_2022_min
      rename :ranking_2021_mix, :ranking_2021_min
      rename :ranking_2020_mix, :ranking_2020_min

      rename :score_2023_mix, :score_2023_min
      rename :score_2022_mix, :score_2022_min
      rename :score_2021_mix, :score_2021_min
      rename :score_2020_mix, :score_2020_min
    end
  end

  def rollback
    alter table_for(University) do
      rename :ranking_2023_min, :ranking_2023_mix
      rename :ranking_2022_min, :ranking_2022_mix
      rename :ranking_2021_min, :ranking_2021_mix
      rename :ranking_2020_min, :ranking_2020_mix

      rename :score_2023_min, :score_2023_mix
      rename :score_2022_min, :score_2022_mix
      rename :score_2021_min, :score_2021_mix
      rename :score_2020_min, :score_2020_mix
    end
  end
end
