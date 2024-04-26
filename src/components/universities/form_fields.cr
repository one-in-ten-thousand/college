class Universities::FormFields < BaseComponent
  needs operation : SaveUniversity

  def render
    div do
      mount Shared::Field, operation.code, "学校代码(唯一)", &.number_input(placeholder: "输入数字, 懒得话, 可以先不填")
      mount Shared::Field, operation.name, "大学名称(不可重复, 唯一)", &.text_input(placeholder: "大学完整名称")
      mount Shared::Field, operation.batch_number, "学校所属的录取批次", &.text_input(placeholder: "例如, A1")
      mount Shared::Field, operation.score_2023_min, "2023学校录取最低分", &.number_input(placeholder: "录取最低分")
      mount Shared::Field, operation.ranking_2023_min, "2023学校录取最低位次", &.number_input(placeholder: "录取最低位次")
      mount Shared::Field, operation.description, "附加信息", &.textarea(rows: 10, cols: 50, placeholder: "随便输入点啥, 可以方便搜索")

      mount CheckBox, operation.is_211, "is_211", "是否 211 大学"

      br

      mount CheckBox, operation.is_985, "is_985", "是否 985 大学"

      br

      mount CheckBox, operation.is_good, "is_good", "是否拥有双一流专业"

      br

      mount AddressSelector, operation

      br
    end
  end
end
