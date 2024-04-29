class CodeRequiredForUniversities::V20240429075927 < Avram::Migrator::Migration::V1
  def migrate
    make_required table_for(University), :code
  end

  def rollback
    make_optional table_for(University), :code
  end
end
