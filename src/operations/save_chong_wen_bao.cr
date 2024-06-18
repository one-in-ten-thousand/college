class SaveChongWenBao < ChongWenBao::SaveOperation
  upsert_lookup_columns user_id, university_id

  permit_columns is_excluded
end
