settings_path="#{Rails.root}/config/settings/"
yml_files = Dir.glob("#{settings_path}*.yml")

if yml_files.present?
  APP_CONFIG = yml_files.inject(Hashie::Mash.new) do |result, file_path|
    raw_config = ERB.new(File.read(file_path)).result
    hashie_name = file_path.gsub("#{settings_path}","")[0...-4]
    result[hashie_name.to_sym] = Hashie::Mash.new(YAML.load(raw_config)[Rails.env])
    result
  end

  puts "Settings for #{Rails.env} loaded"
end
