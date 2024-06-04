module PageHelpers
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
          io << "\n位次比前一年"
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
