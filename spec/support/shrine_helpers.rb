def uploaded_test_file(name, type)
  file = File.open(Rails.root.join("spec/fixtures/files", name), "rb")
  Shrine.upload(file, :store, metadata: { "filename" => name, "mime_type" => type })
end
