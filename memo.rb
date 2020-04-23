# frozen_string_literal: true

require "securerandom"

class Memo
  def initialize(file_name, contents)
    @file_name = file_name
    @contents = contents ? contents : {}
  end

  def create(title, body)
    id = SecureRandom.uuid
    @contents["data#{id}".to_sym] = { id: id, title: title, body: body }
    write_data
  end

  def detail(id)
    @contents["data#{id}".to_sym]
  end

  def title
    memos = @contents.select { |k, v| k =~ /data/ }
    result = {}
    memos.each_key { |k| result[memos[k][:id]] = memos[k][:title] }
    result
  end

  def edit(id, new_title, new_body)
    @contents["data#{id}".to_sym] = { id: id, title: new_title, body: new_body }
    write_data
  end

  def delete(id)
    @contents.delete("data#{id}".to_sym)
    write_data
  end

  def self.read_data(file_name)
    if contents = File.open(file_name) { |file| JSON.load(file) }
      contents.transform_keys!(&:to_sym)
      contents.each_value { |v| v.transform_keys!(&:to_sym) if v.is_a?(Hash) }
    end
    Memo.new(file_name, contents)
  end

  def write_data
    File.open(@file_name, "w") { |file| JSON.dump(@contents, file) }
  end
end
