class Universities::Create < BrowserAction
  post "/universities" do
    SaveUniversity.upsert(params) do |operation, university|
      if university
        flash.success = "The record has been saved"
        redirect Show.with(university.id)
      else
        flash.failure = "It looks like the form is not valid"
        html NewPage, operation: operation
      end
    end
  end
end
