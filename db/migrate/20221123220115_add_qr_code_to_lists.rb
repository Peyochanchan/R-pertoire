class AddQrCodeToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :qr_code, :string
  end
end
