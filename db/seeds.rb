User.create(
  :email => "admin@example.com",
  :password => "secret",
  :admin => true
)

Dir["#{Rails.root}/db/seed/features/*.png"].each do |f|
  Feature.create picture: File.open(f)
end
