class University < BaseModel
  skip_schema_enforcer

  enum BatchLevel
    LevelOne_A  = 0
    LevelOne_A1 = 1
    LevelOne_B  = 2
    LevelTwo_A  = 3
    LevelTwo_B  = 4
    LevelTwo_C  = 5

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

    def self.select_options_level_one
      values = [] of Tuple(String, BatchLevel)

      BatchLevel.each { |bn| values << {bn.display_name, bn} if bn.display_name.starts_with?("一本") }

      values
    end

    def self.select_options_level_two
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

    column ranking_2023_min : Float64?
    column ranking_2022_min : Float64?
    column ranking_2021_min : Float64?
    column ranking_2020_min : Float64?

    column ranking_2023_max : Float64?
    column ranking_2022_max : Float64?
    column ranking_2021_max : Float64?
    column ranking_2020_max : Float64?

    column zhaosheng_zhangcheng_url : String?
    column linian_fenshu_url : String?

    belongs_to province : Province
    belongs_to city : City

    has_many chong_wen_baos : ChongWenBao
  end

  def chong_wen_bao_for(user)
    chong_wen_baos.find do |x|
      x.user_id == user.id
    end
  end

  def remark(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      ""
    else
      cwb.university_remark.to_s
    end
  end

  def marked(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      false
    else
      cwb.is_marked
    end
  end

  def marked_2023(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      false
    else
      cwb.is_marked_2023
    end
  end

  def marked_2022(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      false
    else
      cwb.is_marked_2022
    end
  end

  def marked_2021(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      false
    else
      cwb.is_marked_2021
    end
  end

  def marked_2020(user)
    cwb = chong_wen_bao_for(user)

    if cwb.nil?
      false
    else
      cwb.is_marked_2020
    end
  end

  def city_display_name
    "#{province.name} #{city.name}"
  end
end
