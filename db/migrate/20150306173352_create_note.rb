class CreateNote < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string      :title
      t.text      :body
      t.references  :destination

      t.timestamps
    end
  end
end
