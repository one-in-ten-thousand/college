abstract class MainLayout
  include Lucky::HTMLPage

  # 'needs current_user : User' makes it so that the current_user
  # is always required for pages using MainLayout
  needs current_user : User

  abstract def content
  abstract def page_title

  # MainLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body "hx-boost": true do
        mount Shared::FlashMessages, context.flash
        render_signed_in_user
        main do
          content
        end
      end
    end
  end

  private def render_signed_in_user
    link current_user.email, to: Me::Show
    text " - "
    link(
      "Sign out",
      to: SignIns::Delete,
      flow_id: "sign-out-button",
      "hx-delete": SignIns::Delete.path,
      "hx-target": "body",
      "hx-push-url": true,
      "hx-include": "next input"
    )
    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
  end
end
