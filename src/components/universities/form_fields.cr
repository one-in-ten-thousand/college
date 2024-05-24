class Universities::FormFields < BaseComponent
  needs op : SaveUniversity

  def render
    pp! "Print in form", context.request.headers["Referer"], previous_url(Universities::Index)
    div do
      div class: "row" do
        mount Shared::Field, op.code, "学校代码(唯一)" do |tag|
          tag.number_input(
            placeholder: "输入数字, 这个可以自动查询大学是否已存在",
            "hx-get": "/htmx/v1/universities/find_code",
            "hx-target": "next span",
            "hx-trigger": "change, keyup delay:400ms changed"
          )
        end
        span do
        end
      end

      div class: "row" do
        label_for op.batch_level, "学校所属的录取批次"
        div class: "s12 m8 input-field" do
          select_input op.batch_level do
            select_prompt("点击选择学校所属的录取批次") if op.record.nil?
            optgroup label: "一本" do
              options_for_select(op.batch_level, University::BatchLevel.select_options_level_one)
            end
            optgroup label: "二本" do
              options_for_select(op.batch_level, University::BatchLevel.select_options_level_two)
            end
          end
        end
        mount Shared::FieldErrors, op.batch_level
      end

      div class: "row" do
        mount Shared::Field, op.name, "大学名称", &.text_input(placeholder: "大学完整名称")
      end

      # div class: "row" do
      #   mount Shared::Field, op.score_2023_min, "2023学校录取最低分", &.number_input(placeholder: "录取最低分")
      # end

      # div class: "row" do
      #   mount Shared::Field, op.ranking_2023_min, "2023学校录取最低位次", &.number_input(placeholder: "录取最低位次")
      # end

      fieldset style: "max-width: 800px;" do
        legend "冲稳保选项"
        span class: "row" do
          mount CheckBoxFor, op.chong_2023, "chong_2023", "2023冲"
          mount CheckBoxFor, op.wen_2023, "wen_2023", "2023稳"
          mount CheckBoxFor, op.bao_2023, "bao_2023", "2023保"
        end

        span class: "row" do
          mount CheckBoxFor, op.chong_2022, "chong_2022", "2022冲"
          mount CheckBoxFor, op.wen_2022, "wen_2022", "2022稳"
          mount CheckBoxFor, op.bao_2022, "bao_2022", "2022保"
        end

        span class: "row" do
          mount CheckBoxFor, op.chong_2021, "chong_2021", "2021冲"
          mount CheckBoxFor, op.wen_2021, "wen_2021", "2021稳"
          mount CheckBoxFor, op.bao_2021, "bao_2021", "2021保"
        end

        span class: "row" do
          mount CheckBoxFor, op.chong_2020, "chong_2020", "2020冲"
          mount CheckBoxFor, op.wen_2020, "wen_2020", "2020稳"
          mount CheckBoxFor, op.bao_2020, "bao_2020", "2020保"
        end
      end

      div class: "row" do
        mount Shared::Field, op.description, "附加信息", &.textarea(rows: 10, cols: 50, placeholder: "随便输入点啥, 可以方便搜索", replace_class: "materialize-textarea")
      end

      fieldset do
        legend "其他选项"
        mount CheckBoxFor, op.is_211, "is_211", "是否 211 大学"
        mount CheckBoxFor, op.is_985, "is_985", "是否 985 大学"
        mount CheckBoxFor, op.is_good, "is_good", "是否拥有双一流专业"
      end

      br

      div class: "row" do
        mount AddressSelector, op
      end

      br
    end
  end
end
