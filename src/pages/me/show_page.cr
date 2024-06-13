class Me::ShowPage < MainLayout
  needs users : UserQuery

  def content
    br
    br

    clear_chong_wen_bao

    br

    if current_user.email == "zw963@163.com"
      a(
        "新建用户",
        href: "#modal2",
        class: "waves-effect waves-light btn modal-trigger",
      )
    end

    user_list

    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")

    change_password_modal_dialog
    create_new_user_dialog
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
          "hx-confirm": "确认要删除 冲 数据吗？",
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

    br

    div class: "row" do
      div class: "col m3" do
        link(
          "删除 2023 标记数据",
          Universities::Htmx::Clear2023Mark,
          class: "btn",
          "hx-put": Universities::Htmx::Clear2023Mark.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 2023 标记数据吗？",
        )
      end

      div class: "col m3" do
        link(
          "删除 2022 标记数据",
          Universities::Htmx::Clear2022Mark,
          class: "btn",
          "hx-put": Universities::Htmx::Clear2022Mark.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 2022 标记数据吗？",
        )
      end

      div class: "col m3" do
        link(
          "删除 2021 标记数据",
          Universities::Htmx::Clear2021Mark,
          class: "btn",
          "hx-put": Universities::Htmx::Clear2021Mark.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 2021 标记数据吗？",
        )
      end

      div class: "col m3" do
        link(
          "删除 2020 标记数据",
          Universities::Htmx::Clear2020Mark,
          class: "btn",
          "hx-put": Universities::Htmx::Clear2020Mark.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要删除 2020 标记数据吗？",
        )
      end
    end
  end

  private def user_list
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

                  args = args.merge(disabled: "disabled") if current_user.email != "zw963@163.com"

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

  private def change_password_modal_dialog
    div id: "modal1", class: "modal" do
      div class: "modal-content" do
        h5 "修改密码"
        input(
          type: "password",
          name: "password",
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
          type: "password",
          name: "password_confirmation",
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
          "hx-include": "[name='_csrf'],[name='password'],[name='password_confirmation']",
          id: "set_password",
        )
      end
    end
  end

  private def create_new_user_dialog
    div id: "modal2", class: "modal" do
      div class: "modal-content" do
        h5 "创建新用户"
        label "邮箱", for: "user_email"
        input(
          type: "text",
          name: "user:email",
          id: "user_email",
          script: "on change set x to me.value
then if x != ''
 remove @disabled from <a#create_new_user/>
end
"
        )

        label "密码", for: "user_password"
        input(
          type: "password",
          name: "user:password",
          id: "user_password",
          script: "on change set x to me.value
then set y to (next <input/>).value
then if x == y and x != ''
 remove @disabled from <a#create_new_user/>
else
 set @disabled of <a#create_new_user/> to 'disabled'
end
"
        )

        label "确认密码", for: "user_password_confirmation"
        input(
          type: "password",
          name: "user:password_confirmation",
          id: "user_password_confirmation",
          script: "on change set x to me.value
then set y to (previous <input/>).value
then if x == y and x != ''
 remove @disabled from <a#create_new_user/>
else
 set @disabled of <a#create_new_user/> to 'disabled'
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
          "hx-post": User::Htmx::Create.path,
          "hx-target": "body",
          "hx-include": "[name='_csrf'],[name='user:password'],[name='user:password_confirmation'],[name='user:email']",
          id: "create_new_user",
          disabled: "disabled",
          script: "on mouseover set x to (<#user_email/>).value
then if x == ''
  set @disabled of me to 'disabled'
end
"
        )
      end
    end
  end
end
