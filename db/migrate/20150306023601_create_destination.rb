class CreateDestination < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string     :location
      t.references :user
      t.timestamps
    end
  end
end
