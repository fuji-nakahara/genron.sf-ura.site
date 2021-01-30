# frozen_string_literal: true

def ridgepole_apply(env = Rails.env, dry_run: false)
  ActiveRecord::Base.configurations.configs_for(env_name: env).each do |db_config|
    args = [
      '--config', db_config.config.to_json,
      '--file', Rails.root.join(db_config.config['schemafile_path'] || 'db/Schemafile').to_s,
      '--apply',
    ]
    args << '--dry-run' if dry_run
    system('ridgepole', *args) || abort
  end
end

namespace :ridgepole do
  desc 'Runs `ridgepole --apply`'
  task apply: 'db:load_config' do
    dry_run = (ENV['DRY_RUN'] == 'true')

    environments = [Rails.env]
    environments << 'test' if Rails.env.development? && !dry_run

    environments.each do |env|
      puts "For #{env}" if environments.size > 1
      ridgepole_apply(env, dry_run: dry_run)
    end
  end

  desc 'Runs `ridgepole --apply --dru-run`'
  task 'dry-run': 'db:load_config' do
    ridgepole_apply(dry_run: true)
  end
end
