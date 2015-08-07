# encoding: UTF-8

if !User.any?
  puts "Creating default user..."
  # Default user
  user = User.create!(email: 'admin@tagview.com.br', password: 12345678)

  puts "Generating user's tasks..."
  # Tasks
  [
    { title: "t1", due_date: 1.day.from_now },
    { title: "t2", due_date: 2.days.from_now },
    { title: "t3", due_date: 3.days.from_now }
  ].each do |options|
    task = Task.find_or_initialize_by title: options[:title]
    task.due_date = options[:due_date]
    task.user = user
    task.save!
  end
end

# Applications
if !Doorkeeper::Application.any?
  Doorkeeper::Application.create!(
    uid: "client",
    name: "client",
    redirect_uri: "http://localhost:3001/oauth/callback"
    )
end

puts "All done!"
