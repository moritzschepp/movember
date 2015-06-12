namespace :movember do

  desc "Add ICP Users"
  task :import_users => :environment do 
    data = JSON.parse(File.read MoVember.config["user_import_file"])

    data.each do |user|
      if user["email"].present?
        User.where(:email => user["email"]).first || User.create(
          :email => user["email"]
        )
      end
    end
  end


  desc "Populate the database with some sample data"
  task :populate, [:amount] => :environment do |t, args|
    args.with_defaults(
      :amount => 20
    )
    
    image_dir = "/home/schepp/Desktop/samples/images"
    images = if File.exists?(image_dir)
      Dir["#{image_dir}/*"].map do |f|
        File.open(f)
      end
    else
      []
    end
    
    args[:amount].to_i.times do |i|
      Person.create(
        :first_name => Faker::Name.first_name,
        :last_name => Faker::Name.last_name,
        :description => Faker::Lorem.paragraph,
        :picture => images[(rand * images.size).to_i]
      )
      
      if i % 3 == 0
        Feature.create(
          :name => Faker::Lorem.words(2).join(' ').capitalize,
          :description => Faker::Lorem.paragraph,
          :picture => images[(rand * images.size).to_i]
        )
      end
      
      v = Vote.new
      case i % 5
        when 0 then v.state = 'disabled'
        when 3 then v.state = 'open'
        when 1, 2
          v.state = 'voted'
          
          offset = rand(Person.count)
          v.person = Person.first(:offset => offset)
          
          offset = rand(Feature.count)
          v.feature = Feature.first(:offset => offset)
      end
      v.save
    end
  end
  
  task :raw_votes, [:amount] => :environment do |t, args|
    args.with_defaults(
      :amount => 120
    )
    
    args[:amount].to_i.times do
      offset = rand(Person.count)
      person = Person.first(:offset => offset)
      
      offset = rand(Feature.count)
      feature = Feature.first(:offset => offset)

      offset = rand(User.count)
      user = User.first(:offset => offset)
      
      now = Time.now.strftime '%Y-%m-%d %H:%M:%S'
      
      Vote.connection.execute "INSERT INTO votes 
        (user_id, feature_id, person_id, created_at, updated_at) VALUES 
        (#{user.id}, #{feature.id}, #{person.id}, '#{now}', '#{now}')"
    end
  end
  
end
