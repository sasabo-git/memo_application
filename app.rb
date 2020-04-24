# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "json"
require_relative "memo"

JSON_FILE = "memo.json"

get "/" do
  redirect "/memos"
end

get "/memos" do
  @page = "memos"
  @titles = Memo.read_data(JSON_FILE).title
  erb :index
end

get "/memos/new" do
  @page = "New memo"
  erb :new
end

post "/memos/new" do
  Memo.read_data(JSON_FILE).create(params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*/edit" do |id|
  @title = "Edit Memo"
  @contents = Memo.read_data(JSON_FILE).detail(id)
  erb :edit
end

patch "/memos/*/edit" do |id|
  Memo.read_data(JSON_FILE).edit(id, params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*" do |id|
  @page = "Memo details"
  @contents = Memo.read_data(JSON_FILE).detail(id)
  erb :details
end

delete "/memos/*" do |id|
  Memo.read_data(JSON_FILE).delete(id)
  redirect "/memos"
end
