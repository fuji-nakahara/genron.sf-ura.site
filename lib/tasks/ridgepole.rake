# frozen_string_literal: true

def ridgepole_apply(env = Rails.env, dry_run: false, drop_table: false)
  options = %W[
    --config config/database.yml
    --file db/Schemafile
    --env #{env}
    --apply
  ]
  options << '--dry-run' if dry_run
  options << '--drop-table' if drop_table
  sh 'ridgepole', *options
end

namespace :ridgepole do
  desc 'Updates the DB schema according to db/Schemafile'
  task apply: :environment do
    drop_table = ENV.fetch('DROP_TABLE', false)
    ridgepole_apply(drop_table:)
    ridgepole_apply('test', drop_table:) if Rails.env.development?
  end

  desc 'Display SQLs for DB schema update without executing them'
  task 'dry-run': :environment do
    ridgepole_apply(dry_run: true, drop_table: ENV.fetch('DROP_TABLE', false))
  end
end
