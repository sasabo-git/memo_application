# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "memo"

DATA_BASE = "memo_application"
memos = Memo.connect(DATA_BASE)

get "/" do
  redirect "/memos"
end

get "/memos" do
  @page = "memos"
  @titles = memos.title
  erb :index
end

get "/memos/new" do
  @page = "New memo"
  erb :new
end

post "/memos/new" do
  memos.create(params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*/edit" do |id|
  @title = "Edit Memo"
  @contents = memos.detail(id)
  erb :edit
end

patch "/memos/*/edit" do |id|
  memos.edit(id, params[:title], params[:body])
  redirect "/memos"
end

get "/memos/*" do |id|
  @page = "Memo details"
  @contents = memos.detail(id)
  erb :details
end

delete "/memos/*" do |id|
  memos.delete(id)
  redirect "/memos"
end
