gana do |t1, t2|
  table = new_table do
    primary_key :id
    column :key1, :text
    column :key2, :text
    index :key1, unique: true
    index :key2, unique: true
  end

  t1.begin_transaction
  t1.sync { @id1 = table.insert(key1: 'foo') }

  t2.begin_transaction
  t2.sync { @id2 = table.insert(key2: 'bar') }

  t1.exec { table.where(id: @id1).update(key2: 'bar') }
  t2.exec { table.where(id: @id2).update(key1: 'foo') }

  t1.commit_transaction
  t2.commit_transaction
end
