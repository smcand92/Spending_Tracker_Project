require_relative('../db/sql_runner')
require('pry-byebug')
class Transaction

  attr_accessor :id, :merchant_id, :amount, :tag_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i
    @amount = options['amount'].to_i
  end

  def save()
    sql = "INSERT INTO transactions
    (merchant_id, tag_id, amount)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@merchant_id, @tag_id, @amount]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def update()
    sql = "UPDATE transactions SET (merchant_id, tag_id, amount)=
    ($1, $2, $3) WHERE id = $4"
    values = [@merchant_id, @tag_id, @amount, @id]
    SqlRunner.run(sql, values)
  end


  def self.all()
    sql = "SELECT * FROM transactions"
    results = SqlRunner.run(sql)
    return results.map{|transaction| Transaction.new(transaction)}
  end

  def self.find(id)
    sql = "SELECT * FROM transactions WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Transaction.new(results.first)
  end

  def self.delete_all()
    sql = "DELETE FROM transactions"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM transactions WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def merchant()
    sql = "SELECT * FROM merchants WHERE id = $1"
    values = [@merchant_id]
    merchants= SqlRunner.run(sql, values)
    result = merchants.map{|merchant| Merchant.new(merchant)}
  return result[0]
end

  def tag()
    sql = "SELECT * FROM tags WHERE id = $1"
    values = [@tag_id]
    tags= SqlRunner.run(sql, values)
    result = tags.map{|tag| Tag.new(tag)}
  return result[0]
end

def self.total()
  sql = "SELECT SUM(amount) FROM transactions"
  total = SqlRunner.run(sql)
  return total[0]['sum'].to_i
end



end
