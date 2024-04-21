class UserFactory < Avram::Factory
  def initialize
    email "zw963@163.com"
    encrypted_password Authentic.generate_encrypted_password("123456")
  end
end
