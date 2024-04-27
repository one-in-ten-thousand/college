class Universities::FormFields < BaseComponent
  needs operation : SaveUniversity

  def render
    div do
      mount Shared::Field, operation.code, "学校代码(唯一)" do |tag|
        tag.number_input(
          placeholder: "输入数字, 这个可以自动查询大学是否已存在",
          "hx-get": "/htmx/v1/universities/find_code",
          "hx-target": "next .error",
          "hx-trigger": "change, keyup delay:400ms changed"
        )
      end

      raw <<-'HEREDOC'
        <div class="input-field col s12">
         <label for="form-select-3">学校所属的录取批次</label>
          <select id="form-select-3">
          <option value="">选择学校所属的录取批次</option>
            <optgroup label="第一批">
              <option value="1">Option 1</option>
              <option value="2">Option 2</option>
            </optgroup>
            <optgroup label="第二批">
              <option value="3">Option 3</option>
              <option value="4">Option 4</option>
            </optgroup>
          </select>
        </div>
      HEREDOC

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
