# From http://rny.io/rails/postgresql/2013/07/27/use-uuids-in-rails-4-with-postgresql.html

class EnableUuidOsspExtension < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
  end
end
