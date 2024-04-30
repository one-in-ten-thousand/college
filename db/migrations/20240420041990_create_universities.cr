class CreateUniversities::V20240420041990 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(University) do
      primary_key id : Int64
      add name : String, index: true, unique: true # 大学名称, 必须唯一
      add code : Int32?, index: true, unique: true # 大学的报考编码
      add description : String?                    # 一些其他补充信息

      add score_2023_max : Int32?, index: true # 2023 最高分
      add score_2022_max : Int32?, index: true # 2022 最高分
      add score_2021_max : Int32?, index: true # 2021 最高分
      add score_2020_max : Int32?, index: true # 2020 最高分

      add score_2023_min : Int32?, index: true # 2023 最低分
      add score_2022_min : Int32?, index: true # 2022 最低分
      add score_2021_min : Int32?, index: true # 2021 最低分
      add score_2020_min : Int32?, index: true # 2020 最低分

      add ranking_2023_max : Int32?, index: true # 2023 最高排名
      add ranking_2022_max : Int32?, index: true # 2022 最高排名
      add ranking_2021_max : Int32?, index: true # 2021 最高排名
      add ranking_2020_max : Int32?, index: true # 2020 最高排名

      add ranking_2023_min : Int32?, index: true # 2023 最低排名
      add ranking_2022_min : Int32?, index: true # 2022 最低排名
      add ranking_2021_min : Int32?, index: true # 2021 最低排名
      add ranking_2020_min : Int32?, index: true # 2020 最低排名

      add is_211 : Bool, index: true, default: false          # 是否 211 院校
      add is_985 : Bool, index: true, default: false          # 是否 985 院校
      add is_good : Bool, index: true, default: false         # 是否双一流
      add_belongs_to province : Province, on_delete: :cascade # 所属省份
      add_belongs_to city : City, on_delete: :cascade         # 所属城市
      add_timestamps
    end

    execute <<-'HEREDOC'
CREATE EXTENSION IF NOT EXISTS pgroonga;
HEREDOC

    execute <<-'HEREDOC'
CREATE INDEX university_description_pgroonga_index
          ON universities
       USING pgroonga (description);
HEREDOC
  end

  def rollback
    drop table_for(University)
  end
end
