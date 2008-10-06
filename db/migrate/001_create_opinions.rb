class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.text :description
      t.string :kind, :default => 0
      t.string :dept
      t.integer :votes, :default => 0
      t.text :voters
      t.references :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :opinions
  end
end
