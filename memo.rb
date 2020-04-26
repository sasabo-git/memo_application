# frozen_string_literal: true

require "pg"

class Memo
  def initialize(connections)
    @connections = connections
  end

  def title
    memos = @connections.exec("SELECT * FROM memos")
    result = {}
    memos.each { |memo| result[memo["id"]] = memo["title"] }
    result
  end

  def create(title, body)
    @connections.exec("INSERT INTO memos (title, body) VALUES ('#{title}', '#{body}')")
  end

  def detail(id)
    row = @connections.exec("SELECT * FROM memos WHERE id = '#{id}'")
    { id: row[0]["id"], title: row[0]["title"], body: row[0]["body"] }
  end

  def edit(id, new_title, new_body)
    @connections.exec("UPDATE memos SET title = '#{new_title}', body = '#{new_body}' WHERE id = '#{id}'")
  end

  def delete(id)
    @connections.exec("DELETE FROM memos WHERE id = #{id}")
  end

  def self.connect(db_name)
    connections = PG.connect(host: "localhost", dbname: db_name)
    Memo.new(connections)
  end
end
