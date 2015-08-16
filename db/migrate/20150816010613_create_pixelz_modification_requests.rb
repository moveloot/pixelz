class CreatePixelzModificationRequests < ActiveRecord::Migration
  def change
    create_table :pixelz_modification_requests do |t|
      t.references :modifiable, polymorphic:true
      t.text :pixelz_ticket
      t.datetime :fulfilled_at
      t.text :processed_image_url
      t.text :pixelz_template_id

      t.timestamps
    end
  end
end
