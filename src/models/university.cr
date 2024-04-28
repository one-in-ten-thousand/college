class University < BaseModel
  enum BatchNumber
    LevelOne_A
    LevelOne_A1
    LevelOne_B
    LevelTwo_A
    LevelTwo_B
    LevelTwo_C

    def to_s
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
      values = [] of Tuple(String, University::BatchNumber)

      BatchNumber.each { |bn| values << {bn.to_s, bn} if bn.to_s.starts_with?("一本") }

      values
    end

    def self.checkbox_level_two
      values = [] of Tuple(String, University::BatchNumber)

      BatchNumber.each { |bn| values << {bn.to_s, bn} if bn.to_s.starts_with?("二本") }

      values
    end
  end

  table do
    column name : String
    column description : String?
    column code : Int32?
    column batch_number : String?
    column batch_level : University::BatchNumber
    column is_211 : Bool
    column is_985 : Bool
    column is_good : Bool

    # column score_2023_max : Int32?
    # column ranking_2023_max : Int32?

    column score_2023_min : Int32?
    column ranking_2023_min : Int32?

    belongs_to province : Province
    belongs_to city : City
  end
end
