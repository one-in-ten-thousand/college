class SaveUser < User::SaveOperation
  upsert_lookup_columns email
  attribute password : String

  before_save do
    password.value.try do |password_value|
      encrypted_password.value = Crypto::Bcrypt::Password.create(
        password_value,
        cost: Authentic.settings.encryption_cost
      ).to_s
    end
  end
end
