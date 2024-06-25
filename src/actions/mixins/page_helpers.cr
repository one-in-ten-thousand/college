module PageHelpers
  def show_university_batch_levels(university_name, university_code, university_batch_level)
    batch_names = UniversityQuery.new
      .name.like("#{university_name}%")
      .reject { |e| e.code == university_code && e.batch_level == university_batch_level }
      .map { |e| [e.name, e.batch_level.display_name] }

    str = String.build do |io|
      io << "名称相似的其他学校:"

      if batch_names.blank?
        io << " 无"
      else
        io << "\n\n"

        batch_names.each do |e|
          io << "#{e[0]}, #{e[1]}\n"
        end
      end
    end
  end

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
        base_score = base_score_2022
        unless university.score_2022_min.nil? || university.score_2021_min.nil?
          score_offset = (university.score_2022_min.not_nil!.to_i - base_score_2022) - (university.score_2021_min.not_nil!.to_i - base_score_2021)
        end
      when 2021
        base_score = base_score_2021
        unless university.score_2021_min.nil? || university.score_2020_min.nil?
          score_offset = (university.score_2021_min.not_nil!.to_i - base_score_2021) - (university.score_2020_min.not_nil!.to_i - base_score_2020)
        end
      when 2020
        base_score = base_score_2020
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

        base_ranking_min = 42972.42458

        unless university.ranking_2023_min.nil?
          current_ranking_offset = university.ranking_2023_min.not_nil!.to_i - base_ranking_min.to_i
        end
      when 2022
        unless university.ranking_2022_min.nil? || university.ranking_2021_min.nil?
          ranking_offset = university.ranking_2022_min.not_nil!.to_i - university.ranking_2021_min.not_nil!.to_i
        end
        base_ranking_min = 35905.35321

        unless university.ranking_2022_min.nil?
          current_ranking_offset = university.ranking_2022_min.not_nil!.to_i - base_ranking_min.to_i
        end
      when 2021
        unless university.ranking_2021_min.nil? || university.ranking_2020_min.nil?
          ranking_offset = university.ranking_2021_min.not_nil!.to_i - university.ranking_2020_min.not_nil!.to_i
        end
        base_ranking_min = 34766.34225

        unless university.ranking_2021_min.nil?
          current_ranking_offset = university.ranking_2021_min.not_nil!.to_i - base_ranking_min.to_i
        end
      when 2020
        base_ranking_min = 32871.32357

        unless university.ranking_2020_min.nil?
          current_ranking_offset = university.ranking_2020_min.not_nil!.to_i - base_ranking_min.to_i
        end
      end

      str = String.build do |io|
        io << "同分段 #{same_ranking_count} 人"

        unless current_ranking_offset.nil?
          io << "\n"

          if current_ranking_offset >= 0
            io << "投档线超过一本线"
          else
            io << "投档线低于一本线"
          end

          io << " #{current_ranking_offset.abs} 位"
        end

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

        io << "\n\n备注: 一本线对应位次: #{base_ranking_min}"
      end

      str
    end
  end
end
