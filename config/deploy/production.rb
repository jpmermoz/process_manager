set :stage, :production
set :rails_env, "production"

server 'jpmermoz.codingways.com', user: 'codingways', port: 22, roles: %w{web app db}