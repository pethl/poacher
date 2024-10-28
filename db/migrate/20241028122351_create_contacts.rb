class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :business_name
      t.string :contact_name
      t.string :reference
      t.string :email
      t.string :mobile
      t.string :phone
      t.string :country
      t.string :address
      t.text :notes

      t.timestamps
    end
  end
end
