# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "json"

enable :method_override

class Memo
  def initialize(file_name, contents, max_id_number)
    @file_name = file_name
    @contents = contents ? contents : {}
    @max_id_number = max_id_number ? max_id_number : 0
  end

  def create(title, body)
    @max_id_number += 1
    @contents[:max_id_number] = @max_id_number
    @contents["data#{@max_id_number}".to_sym] = { id: @max_id_number, title: title, body: body }
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
      max_id_number = contents[:max_id_number]
    end
    Memo.new(file_name, contents, max_id_number)
  end

  def write_data
    File.open(@file_name, "w") { |file| JSON.dump(@contents, file) }
  end
end

JSON_FILE = "memo.json"
memo = Memo.read_data(JSON_FILE)

get "/" do
  @page = "Top"
  @titles = memo.title
  erb :index
end

get "/create" do
  @page = "New memo"
  erb :create
end

post "/add" do
  memo.create(params[:title], params[:body])
  redirect "/"
end

get "/show/*" do |id|
  @page = "Show Memo"
  @contents = memo.detail(id)
  erb :show
end

get "/edit/*" do |id|
  @title = "Edit Memo"
  @contents = memo.detail(id)
  erb :edit
end

patch "/edit/*" do |id|
  memo.edit(id, params[:title], params[:body])
  redirect "/"
end

delete "/show/*" do |id|
  memo.delete(id)
  redirect "/"
end
