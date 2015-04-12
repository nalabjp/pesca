class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :provider,    null: false,  limit: 32
      t.string  :event_id,    null: false,  limit: 16
      t.string  :title,       null: false
      t.text    :description,               limit: 16777215
      t.text    :catch,                     limit: 16777215
      t.string  :address
      t.string  :event_url,   null: false

      t.timestamps null: false
    end
    add_index :events, [:provider, :event_id], unique: true, name: 'unique_on_provider_and_event_id'
  end
end
