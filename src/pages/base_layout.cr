abstract class BaseLayout
  include Lucky::HTMLPage

  def render
    content
  end

  private def show_ranking_number(ranking_value)
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

      "#{low_ranking.to_i - high_ranking.to_i} 位"
    end
  end
end
