class Universities::FormFields < BaseComponent
  needs op : SaveUniversity
  needs current_user : User

  def render
    div do
      if current_user.is_editable
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
      end

      if current_user.is_editable
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
      else
        div class: "row" do
          div class: "m4" do
            h4 "#{op.name.value}(#{op.code.value})"
          end
          div class: "m2" do
            h4 op.batch_level.value.not_nil!.display_name
          end
          div class: "m2" do
            if op.is_211.value
              h4 "211 院校"
            elsif op.is_985.value
              h4 "985 院校"
            elsif op.is_good.value
              h4 "双一流"
            end
          end
          div class: "m3" do
            h4 "#{op.record.not_nil!.city_display_name}"
          end
        end
      end

      if op.record
        fieldset style: "max-width: 800px;" do
          legend "冲稳保选项"
          span class: "row" do
            span class: "s3" do
              mount CheckBoxFor, op.chong_2023, "chong_2023", "2023冲", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.chong_2022, "chong_2022", "2022冲", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.chong_2021, "chong_2021", "2021冲", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.chong_2020, "chong_2020", "2020冲", op.record
            end
          end

          br

          span class: "row" do
            span class: "s3" do
              mount CheckBoxFor, op.wen_2023, "wen_2023", "2023稳", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.wen_2022, "wen_2022", "2022稳", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.wen_2021, "wen_2021", "2021稳", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.wen_2020, "wen_2020", "2020稳", op.record
            end
          end

          br

          span class: "row" do
            span class: "s3" do
              mount CheckBoxFor, op.bao_2023, "bao_2023", "2023保", op.record
            end
            span class: "s3" do
              mount CheckBoxFor, op.bao_2022, "bao_2022", "2022保", op.record
            end

            span class: "s3" do
              mount CheckBoxFor, op.bao_2021, "bao_2021", "2021保", op.record
            end

            span class: "s3" do
              mount CheckBoxFor, op.bao_2020, "bao_2020", "2020保", op.record
            end
          end
        end
      end

      br

      div class: "row" do
        mount Shared::Field, op.university_remark, "学校附加信息", &.textarea(
          rows: 10,
          cols: 50,
          style: "min-width: 600px; min-height: 300px; max-height: 500px; overflow: scroll;",
          placeholder: "随便输入点啥, 可以方便的在首页模糊搜索",
          replace_class: "materialize-textarea"
        )
      end

      br

      div class: "row" do
        mount Shared::Field, op.linian_fenshu_url, "历年分数(网址)", &.text_input(placeholder: "输入历年分数网址 URL")
      end

      br

      div class: "row" do
        mount Shared::Field, op.zhaosheng_zhangcheng_url, "招生章程(网址)", &.text_input(placeholder: "输入招生章程网址 URL")
      end

      br

      if current_user.is_editable
        fieldset style: "max-width: 800px;" do
          legend "其他选项"
          span class: "row" do
            span class: "s4" do
              mount CheckBoxFor, op.is_211, "is_211", "是否 211 大学", op.record
            end

            span class: "s4" do
              mount CheckBoxFor, op.is_985, "is_985", "是否 985 大学", op.record
            end

            span class: "s4" do
              mount CheckBoxFor, op.is_good, "is_good", "是否拥有双一流专业", op.record
            end
          end
        end

        br

        div class: "row" do
          mount AddressSelector, op
        end
      end

      br

      input(type: "hidden", value: op.current_user_id.value.to_s, name: "university:current_user_id")
    end
  end
end
