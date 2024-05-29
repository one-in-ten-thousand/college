class Me::ShowPage < MainLayout
  needs users : UserQuery

  def content
    br
    br

    clear_chong_wen_bao

    table class: "highlight" do
      thead do
        tr do
          th "ID"
          th "用户邮箱"
          th "创建日期"
          th "修改日期"
          th "是否可编辑"
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
                    type: "checkbox",
                    name: "is_editable",
                    value: true,
                    id: "#{user_id}_is_editable",
                    "hx-put": User::Htmx::Editable.with(user.id).path,
                    "hx-swap": "none",
                    "hx-confirm": "确认？",
                    "hx-include": "[name='_csrf']"
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
          end
        end
      end
    end

    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
  end

  private def clear_chong_wen_bao
    div class: "row" do
      div class: "col m4" do
        link(
          "清除用户冲数据",
          Me::ClearChong,
          class: "btn",
          "hx-put": Me::ClearChong.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要清除标记的冲数据吗？",
        )
      end

      div class: "col m4" do
        link(
          "清除用户稳数据",
          Me::ClearWen,
          class: "btn",
          "hx-put": Me::ClearWen.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要清除标记的稳数据吗？",
        )
      end

      div class: "col m4" do
        link(
          "清除用户保数据",
          Me::ClearChong,
          class: "btn",
          "hx-put": Me::ClearBao.path,
          "hx-swap": "none",
          "hx-include": "[name='_csrf']",
          "hx-confirm": "确认要清除标记的保数据吗？",
        )
      end
    end
  end
end
