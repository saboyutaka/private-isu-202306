require 'mysql2'

def config
  @config ||= {
    db: {
      host: ENV['ISUCONP_DB_HOST'] || 'localhost',
      port: ENV['ISUCONP_DB_PORT'] && ENV['ISUCONP_DB_PORT'].to_i,
      username: 'isuconp',
      password: 'isuconp',
      database: ENV['ISUCONP_DB_NAME'] || 'isuconp',
    },
  }
end

def db
  return Thread.current[:isuconp_db] if Thread.current[:isuconp_db]
  client = Mysql2::Client.new(
    host: config[:db][:host],
    port: config[:db][:port],
    username: config[:db][:username],
    password: config[:db][:password],
    database: config[:db][:database],
    encoding: 'utf8mb4',
    reconnect: true,
  )
  client.query_options.merge!(symbolize_keys: true, database_timezone: :local, application_timezone: :local)
  Thread.current[:isuconp_db] = client
  client
end

post_ids = db.prepare('SELECT id FROM `posts`').execute.to_a.map {|p| p[:id] }

post_ids.each do |id|
  post = db.prepare('SELECT * FROM `posts` WHERE `id` = ?').execute(id).first

  ext = ""
  if post[:mime] == "image/jpeg"
    ext = ".jpg"
  elsif post[:mime] == "image/png"
    ext = ".png"
  elsif post[:mime] == "image/gif"
    ext = ".gif"
  end

  file_name = "#{post[:id]}#{ext}"

  File.write("../public/image/#{file_name}",  post[:imgdata])

  print '.'
end
