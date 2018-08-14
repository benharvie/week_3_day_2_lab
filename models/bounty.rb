require 'pg'

class Bounty
  attr_accessor :name, :species, :favourite_weapon, :bounty_value
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @species = options['species']
    @favourite_weapon = options['favourite_weapon']
    @bounty_value = options['bounty_value'].to_i
  end

  def save
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "INSERT INTO bounties
    (name, species, favourite_weapon, bounty_value)
    VALUES
    ($1, $2, $3, $4) RETURNING *"
    values = [@name, @species, @favourite_weapon, @bounty_value]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]['id'].to_i
    db.close
  end

  def delete
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "DELETE FROM bounties
    WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def update
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "UPDATE bounties
    SET
    (name, species, favourite_weapon, bounty_value) =
    ($1, $2, $3, $4)
    WHERE id = $5"
    values = [@name, @species, @favourite_weapon, @bounty_value, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close
  end

  def self.all
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "SELECT * FROM bounties"
    db.prepare("all", sql)
    bounties = db.exec_prepared("all")
    db.close
    return bounties.map { |bounty| Bounty.new(bounty) }
  end

  def self.delete_all
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "DELETE FROM bounties"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def self.find_by_name(bounty_name)
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "SELECT * FROM bounties
    WHERE name = '#{bounty_name}'"
    db.prepare("find_by_name", sql)
    found = db.exec_prepared("find_by_name")
    db.close

    found.count > 0 ? found[0] : nil
  end

  def self.find_by_id(bounty_id)
    db = PG.connect({ dbname: 'bounty', host: 'localhost' })
    sql = "SELECT * FROM bounties
    WHERE id = '#{bounty_id}'"
    db.prepare("find_by_id", sql)
    found = db.exec_prepared("find_by_id")
    db.close

    found.count > 0 ? found[0] : nil
  end
end
