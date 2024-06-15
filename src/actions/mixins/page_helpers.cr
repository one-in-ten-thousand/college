module PageHelpers
  def show_score_info(university, year, score_value)
    if score_value.blank?
      ""
    else
      base_score_2023 = 480
      base_score_2022 = 498
      base_score_2021 = 505
      base_score_2020 = 537

      case year
      when 2023
        base_score = base_score_2023
        unless university.score_2023_min.nil? || university.score_2022_min.nil?
          score_offset = (university.score_2023_min.not_nil!.to_i - base_score_2023) - (university.score_2022_min.not_nil!.to_i - base_score_2022)
        end
      when 2022
        base_score = 498
        unless university.score_2022_min.nil? || university.score_2021_min.nil?
          score_offset = (university.score_2022_min.not_nil!.to_i - base_score_2022) - (university.score_2021_min.not_nil!.to_i - base_score_2021)
        end
      when 2021
        base_score = 505
        unless university.score_2021_min.nil? || university.score_2020_min.nil?
          score_offset = (university.score_2021_min.not_nil!.to_i - base_score_2021) - (university.score_2020_min.not_nil!.to_i - base_score_2020)
        end
      when 2020
        base_score = 537
      end

      unless base_score.nil?
        value = score_value.not_nil!.to_i - base_score

        str = String.build do |io|
          io << "一本线(#{base_score})#{value > 0 ? "以上" : "以下"} #{value.abs} 分"
          unless score_offset.nil?
            io << "\n距一本线比上一年"
            if score_offset > 0
              io << "高 "
            else
              io << "低 "
            end

            io << score_offset.abs
            io << " 分"
          end
        end
      end

      str.to_s
    end
  end

  def show_ranking_info(university, year, ranking_value)
    if ranking_value.blank?
      ""
    else
      value = ranking_value.to_s.split('.')
      if value.size != 2
        return ""
      else
        low_ranking, high_ranking = value
      end

      size = low_ranking.size
      high_ranking = high_ranking.ljust(size, '0')

      same_ranking_count = low_ranking.to_i - high_ranking.to_i

      case year
      when 2023
        unless university.ranking_2023_min.nil? || university.ranking_2022_min.nil?
          ranking_offset = university.ranking_2023_min.not_nil!.to_i - university.ranking_2022_min.not_nil!.to_i
        end
      when 2022
        unless university.ranking_2022_min.nil? || university.ranking_2021_min.nil?
          ranking_offset = university.ranking_2022_min.not_nil!.to_i - university.ranking_2021_min.not_nil!.to_i
        end
      when 2021
        unless university.ranking_2021_min.nil? || university.ranking_2020_min.nil?
          ranking_offset = university.ranking_2021_min.not_nil!.to_i - university.ranking_2020_min.not_nil!.to_i
        end
      end

      str = String.build do |io|
        io << "同分段 #{same_ranking_count} 人"

        unless ranking_offset.nil?
          io << "\n位次比上一年"
          if ranking_offset > 0
            io << "下降 "
          else
            io << "提升 "
          end

          io << ranking_offset.abs
          io << " 位"
        end
      end

      str
    end
  end
end
