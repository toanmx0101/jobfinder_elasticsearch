task generate_real_user: :environment do
  # Fetch and parse HTML document
  file = "real_user.json"

  File.open(file, "w") do |tt_json|
    tt_json.puts '['
    User.where('id > 2').first(40).each do |u|
      tt_json.puts '{"work_position": "' + u&.work_position  + '", "description": "' + u&.description + '", "experience": "' + u&.experience  + '", "education": "' + u&.education + '"}'
    end
    tt_json.puts ']'
  end
end