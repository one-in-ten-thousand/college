class AddIsEditableToUsers::V20240529040330 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add is_editable : Bool, default: false
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
