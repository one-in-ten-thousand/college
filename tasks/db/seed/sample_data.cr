require "../../../spec/support/factories/**"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::Seed::RequiredData` if you need to create data *required* for your
# app to work.
class Db::Seed::SampleData < LuckyTask::Task
  summary "Add sample database records helpful for development"

  def call
    Signal::INT.trap do
      print_exit("\n按下 Ctrl C")
    end

    print "重置所有开发数据？（y/yes 继续）"
    input = gets.try &.rstrip

    print_exit("拒绝执行") unless input.to_s.downcase.in? ["y", "yes"]

    ProvinceQuery.truncate(cascade: true)

    # Using an Avram::Factory:
    #
    # Use the defaults, but override just the email
    # UserFactory.create &.email("me@example.com")

    # Using a SaveOperation:
    # ```
    # SignUpUser.create!(email: "me@example.com", password: "test123", password_confirmation: "test123")
    # ```
    #
    # You likely want to be able to run this file more than once. To do that,
    # only create the record if it doesn't exist yet:
    # ```
    # if UserQuery.new.email("me@example.com").none?
    #   SignUpUser.create!(email: "me@example.com", password: "test123", password_confirmation: "test123")
    # end
    # ```
    puts "Done adding sample data"
  end

  def print_exit(reason)
    STDERR.puts reason
    STDERR.puts "退出 ..."
    exit
  end
end
