class Universities::ShowPage < MainLayout
  needs university : University
  needs user_chong_wen_bao : ChongWenBao?
  quick_def page_title, "University with id: #{university.id}"

  def content
    link "返回列表", Index
    h3 "大学 ID: #{university.id}"
    render_actions
    render_university_fields
  end

  def render_actions
    section do
      link "编辑", Edit.with(university.id)
      text " | "

      if current_user.email == "zw963@163.com"
        link(
          "删除",
          Delete.with(university.id),
          "hx-target": "body",
          "hx-confirm": "确定删除吗?",
          "hx-push-url": "true",
          "hx-delete": Delete.with(university.id).path,
          "hx-include": "next input"
        )
      end
      input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
    end
  end

  def render_university_fields
    ul do
      li do
        text "编码: "
        strong university.code
      end

      li do
        text "录取批次: "
        strong university.batch_level.display_name
      end

      li do
        text "名称: "
        strong university.name.to_s
      end

      li do
        text "补充信息: "
        strong university.description.to_s
      end

      li do
        text "所在省市: "
        strong "#{university.province.name} #{university.city.name}"
      end

      li do
        text "各年录取最低分数线: "
        ul do
          li "2023年: #{university.score_2023_min}"
          li "2022年: #{university.score_2022_min}"
          li "2021年: #{university.score_2021_min}"
          li "2020年: #{university.score_2020_min}"
        end
      end

      li do
        text "各年录取最低位次: "
        ul do
          li "2023年: #{university.ranking_2023_min}"
          li "2022年: #{university.ranking_2022_min}"
          li "2021年: #{university.ranking_2021_min}"
          li "2020年: #{university.ranking_2020_min}"
        end
      end

      if !(cwb = user_chong_wen_bao).nil?
        li do
          text "冲稳保: "

          div class: "row" do
            fieldset style: "width: 100px;" do
              legend "2023年"
              li do
                text "冲" if cwb.chong_2023
                text "稳" if cwb.wen_2023
                text "保" if cwb.bao_2023
              end
            end

            fieldset style: "width: 100px;" do
              legend "2022年"
              li do
                text "冲" if cwb.chong_2022
                text "稳" if cwb.wen_2022
                text "保" if cwb.bao_2022
              end
            end

            fieldset style: "width: 100px;" do
              legend "2021年"
              li do
                text "冲" if cwb.chong_2021
                text "稳" if cwb.wen_2021
                text "保" if cwb.bao_2021
              end
            end

            fieldset style: "width: 100px;" do
              legend "2020年"
              li do
                text "冲" if cwb.chong_2020
                text "稳" if cwb.wen_2020
                text "保" if cwb.bao_2020
              end
            end
          end
        end
      end

      li do
        text "创建时间: "
        strong university.created_at.to_s("%m月%d日 %H:%M:%S")
      end

      li do
        text "修改时间: "
        strong university.updated_at.to_s("%m月%d日 %H:%M:%S")
      end
    end
  end
end
