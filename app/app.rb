require 'bundler/setup'
Bundler.require
require 'aws-record'

class CountTable
  include Aws::Record
  string_attr :id, hash_key: true
  integer_attr :number
  epoch_time_attr :ts
end


before do
  if CountTable.scan().empty?
    table = CountTable.new(id: SecureRandom.uuid,number: 0,ts: Time.now)
    table.save!
  end
end

get '/' do
  table = CountTable.scan()
  @number = table.first.number
  erb :index
end

get '/plus' do
  table = CountTable.scan()
  count = table.first
  number = count.number + 1
  record = CountTable.update(id: count.id,number: number,ts: Time.now)
  redirect "https://serverless-count.gahaku.tech/"
end

get '/minus' do
  table = CountTable.scan()
  count = table.first
  number = count.number - 1
  record = CountTable.update(id: count.id,number: number,ts: Time.now)
  redirect "https://serverless-count.gahaku.tech/"
end
