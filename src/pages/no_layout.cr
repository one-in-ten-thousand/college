abstract class NoLayout
  include Lucky::HTMLPage
  needs current_user : User

  def render
    content
  end
end
