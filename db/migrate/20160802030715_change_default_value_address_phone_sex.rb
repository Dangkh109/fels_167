class ChangeDefaultValueAddressPhoneSex < ActiveRecord::Migration
  def change
     change_column :users, :sex, :boolean, default: false
     change_column :users, :phone, :string, default: ""
     change_column :users, :address, :string, default: ""
  end
end
