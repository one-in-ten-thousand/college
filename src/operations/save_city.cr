class SaveCity < City::SaveOperation
  upsert_lookup_columns name
  permit_columns name

  before_save do
    validate_required name
    validate_uniqueness_of name
  end
end
