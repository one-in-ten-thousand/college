class AddIndexToIsMarkedForChongWenBao::V20240613010329 < Avram::Migrator::Migration::V1
  def migrate
    create_index table_for(ChongWenBao), [:is_marked]
  end

  def rollback
    drop_index table_for(ChongWenBao), [:is_marked], if_exists: true
  end
end
