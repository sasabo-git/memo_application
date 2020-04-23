# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "json"
require_relative "memo"

JSON_FILE = "memo.json"
memo = Memo.read_data(JSON_FILE)

get "/" do
  redirect "/memos"
end

get "/memos" do
  @page = "memos"
  @titles = memo.title
  erb :index
end

get "/memos/new" do
  @page = "New memo"
  erb :new
end

post "/memos/new" do
  memo.create(params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*/edit" do |id|
  @title = "Edit Memo"
  @contents = memo.detail(id)
  erb :edit
end

patch "/memos/*/edit" do |id|
  memo.edit(id, params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*" do |id|
  @page = "Memo details"
  @contents = memo.detail(id)
  erb :details
end

delete "/memos/*" do |id|
  memo.delete(id)
  redirect "/memos"
end
