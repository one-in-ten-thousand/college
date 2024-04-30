class University < BaseModel
  skip_schema_enforcer

  enum BatchLevel
    LevelOne_A
    LevelOne_A1
    LevelOne_B
    LevelTwo_A
    LevelTwo_B
    LevelTwo_C

    def display_name
      case self
      in LevelOne_A
        "一本A"
      in LevelOne_A1
        "一本A1"
      in LevelOne_B
        "一本B"
      in LevelTwo_A
        "二本A"
      in LevelTwo_B
        "二本B"
      in LevelTwo_C
        "二本C"
      end
    end

    def self.checkbox_level_one
      values = [] of Tuple(String, BatchLevel)

      BatchLevel.each { |bn| values << {bn.display_name, bn} if bn.display_name.starts_with?("一本") }

      values
    end

    def self.checkbox_level_two
      values = [] of Tuple(String, BatchLevel)

      BatchLevel.each { |bn| values << {bn.display_name, bn} if bn.display_name.starts_with?("二本") }

      values
    end
  end

  table do
    column name : String
    column description : String?
    column code : Int32
    column batch_level : University::BatchLevel
    column is_211 : Bool
    column is_985 : Bool
    column is_good : Bool

    column score_2023_min : Int32?
    column score_2022_min : Int32?
    column score_2021_min : Int32?
    column score_2020_min : Int32?

    column score_2023_max : Int32?
    column score_2022_max : Int32?
    column score_2021_max : Int32?
    column score_2020_max : Int32?

    column ranking_2023_min : Int32?
    column ranking_2022_min : Int32?
    column ranking_2021_min : Int32?
    column ranking_2020_min : Int32?

    column ranking_2023_max : Int32?
    column ranking_2022_max : Int32?
    column ranking_2021_max : Int32?
    column ranking_2020_max : Int32?

    belongs_to province : Province
    belongs_to city : City
  end
end
