class Shared::PasswordDialog < BaseComponent
  def render
    div id: "modal1", class: "modal" do
      div class: "modal-content" do
        h5 "修改密码"
        input type: "text", name: "password"
        input type: "text", name: "confirm_password"
      end

      div class: "modal-footer" do
        a "取消", href: "#!", class: "modal-close waves-effect btn-flat"
        yield
      end
    end
  end
end
