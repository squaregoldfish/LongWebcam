# Load the custom configuration entries
GRUNT_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]