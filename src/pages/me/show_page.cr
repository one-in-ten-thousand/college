class Me::ShowPage < MainLayout
  def content
    h2 "个人信息"
    h3 "邮箱名:  #{@current_user.email}"
    link(
      "清除用户冲数据",
      Me::ClearChong,
      class: "btn",
      "hx-put": Me::ClearChong.path,
      "hx-swap": "none",
      "hx-include": "[name='_csrf']",
      "hx-confirm": "确认要清除标记的冲数据吗？",
    )

    br
    br

    link(
      "清除用户稳数据",
      Me::ClearWen,
      class: "btn",
      "hx-put": Me::ClearWen.path,
      "hx-swap": "none",
      "hx-include": "[name='_csrf']",
      "hx-confirm": "确认要清除标记的稳数据吗？",
    )

    br
    br

    link(
      "清除用户保数据",
      Me::ClearChong,
      class: "btn",
      "hx-put": Me::ClearBao.path,
      "hx-swap": "none",
      "hx-include": "[name='_csrf']",
      "hx-confirm": "确认要清除标记的保数据吗？",
    )

    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
  end
end
