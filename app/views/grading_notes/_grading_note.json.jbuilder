json.extract! grading_note, :id, :makesheet_id, :date, :appearance, :bore, :texture, :taste, :score, :head_taster, :assistant_taster_1, :assistant_taster_2, :created_at, :updated_at
json.url grading_note_url(grading_note, format: :json)
