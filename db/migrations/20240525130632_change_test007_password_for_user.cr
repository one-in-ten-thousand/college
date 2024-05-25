class ChangeTest007PasswordForUser::V20240525130632 < Avram::Migrator::Migration::V1
  def migrate
    user = UserQuery.new.email("test007@zw963.top").first
    SaveUser.update!(user, password: "1234567")
  end

  def rollback
    # drop table_for(Thing)
  end
end
