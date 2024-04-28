class UpdateBatchLevelData::V20240427102500 < Avram::Migrator::Migration::V1
  def migrate
    UniversityQuery.new.each do |university|
      university.batch_number
      if university.batch_number == "A"
        SaveUniversity.update!(university, batch_level: University::BatchNumber::LevelOne_A)
      end
    end

    # make_required table_for(University), :batch_level
  end

  def rollback
  end
end
