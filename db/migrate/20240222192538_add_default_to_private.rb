class AddDefaultToPrivate < ActiveRecord::Migration[7.0]
  def change
    change_column_default(

      :users, # table_name,
      :private, # column_name,
      true # default
    )
  end
end
