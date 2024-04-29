class Universities::FormFields < BaseComponent
  needs op : CreateUniversity

  def render
    div do
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
      div class: "input-field" do
        label_for op.batch_level, "选择学校所属的录取批次"
        select_input op.batch_level do
          select_prompt("选择学校所属的录取批次") if op.record.nil?
          optgroup label: "一本" do
            options_for_select(op.batch_level, University::BatchLevel.checkbox_level_one)
          end
          optgroup label: "二本" do
            options_for_select(op.batch_level, University::BatchLevel.checkbox_level_two)
          end
        end
      end

      mount Shared::Field, op.name, "大学名称", &.text_input(placeholder: "大学完整名称")
      mount Shared::Field, op.score_2023_min, "2023学校录取最低分", &.number_input(placeholder: "录取最低分")
      mount Shared::Field, op.ranking_2023_min, "2023学校录取最低位次", &.number_input(placeholder: "录取最低位次")
      mount Shared::Field, op.description, "附加信息", &.textarea(rows: 10, cols: 50, placeholder: "随便输入点啥, 可以方便搜索")

      mount CheckBox, op.is_211, "is_211", "是否 211 大学"

      br

      mount CheckBox, op.is_985, "is_985", "是否 985 大学"

      br

      mount CheckBox, op.is_good, "is_good", "是否拥有双一流专业"

      br

      mount AddressSelector, op

      br
    end
  end
end
