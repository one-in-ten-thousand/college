class Me::ShowPage < MainLayout
  needs users : UserQuery

  def content
    br
    br

    clear_chong_wen_bao

    br

    edit_user_editable

    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")

    div id: "modal1", class: "modal" do
      div class: "modal-content" do
        h5 "修改密码"
        input(
          type: "text",
          name: "password",
          id: "password",
          script: "on change set x to me.value
then set y to (next <input/>).value
then if x == y and x != ''
 remove @disabled from <a#set_password/>
else
 set @disabled of <a#set_password/> to 'disabled'
end
"
        )
        input(
          type: "text",
          name: "confirm_password",
          id: "confirm_password",
          script: "on change set x to me.value
then set y to (previous <input/>).value
then if x == y and x != ''
 remove @disabled from <a#set_password/>
else
 set @disabled of <a#set_password/> to 'disabled'
end
"
        )
      end

      div class: "modal-footer" do
        a "取消", href: "#!", class: "modal-close waves-effect btn-flat"
        a(
          "确认",
          href: "#!",
          class: "modal-close waves-effect btn-flat",
          "hx-put": "will_be_replace_when_clicking",
          "hx-swap": "none",
          "hx-include": "[name='_csrf'],[name='password']",
          id: "set_password",
        )
      end
    end
  end

  private def clear_chong_wen_bao
    div class: "row" do
      div class: "col m4" do
        link(
          "删除 冲 数据",
          Me::ClearChong,
          class: "btn",
          "hx-put": Me::ClearChong.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要清除冲数据吗？",
        )
      end

      div class: "col m4" do
        link(
          "删除 稳 数据",
          Me::ClearWen,
          class: "btn",
          "hx-put": Me::ClearWen.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 稳 数据吗？",
        )
      end

      div class: "col m4" do
        link(
          "删除 保 数据",
          Me::ClearChong,
          class: "btn",
          "hx-put": Me::ClearBao.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 保 数据吗？",
        )
      end
    end
  end

  private def edit_user_editable
    table class: "highlight" do
      thead do
        tr do
          th "ID"
          th "用户邮箱"
          th "创建日期"
          th "修改日期"
          th "是否可编辑"
          th "设置新密码"
        end
      end

      tbody do
        users.each do |user|
          user_id = user.id
          tr do
            td user_id
            td user.email
            td user.created_at.to_s("%m月%d日 %H:%M:%S")
            td user.updated_at.to_s("%m月%d日 %H:%M:%S")
            td do
              span class: "switch" do
                label for: "#{user_id}_is_editable" do
                  args = {
                    type:         "checkbox",
                    name:         "is_editable",
                    value:        true,
                    id:           "#{user_id}_is_editable",
                    "hx-put":     User::Htmx::Editable.with(user.id).path,
                    "hx-swap":    "none",
                    "hx-confirm": "确认？",
                    "hx-include": "[name='_csrf']",
                  }

                  if user.is_editable
                    input(args.merge(checked: "checked"))
                  else
                    input(args)
                  end

                  span class: "lever"
                end
              end
            end

            td do
              a(
                "修改密码",
                href: "#modal1",
                class: "waves-effect waves-light btn modal-trigger",
                script: "
on click put '修改 #{user.email} 的密码' into the <#modal1 h5/>
then set @hx-put of <#modal1 a[hx-put]/> to '#{User::Htmx::Password.with(user_id).path}'
then js htmx.process(document.body) end
"
              )
            end
          end
        end
      end
    end
  end
end
