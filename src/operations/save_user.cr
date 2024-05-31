class SaveUser < User::SaveOperation
  upsert_lookup_columns email
  attribute password : String
  attribute password_confirmation : String
  attribute action : String

  before_save do
    pp! action
    pp! action.value
    case action.value
    when "reset_password"
      validate_required password
      validate_confirmation_of password, with: password_confirmation

      password.value.try do |password_value|
        encrypted_password.value = Crypto::Bcrypt::Password.create(
          password_value,
          cost: Authentic.settings.encryption_cost
        ).to_s
      end
    end
  end
end
