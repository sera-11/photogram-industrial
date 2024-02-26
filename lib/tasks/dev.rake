desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"

  #destroys data everytime we run sample_data so it's not creating on top of existing users
  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  #create email and passwords
  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
  end
  

  #Creates the users 
  12.times do 
    name = Faker::Name.unique.first_name
    u = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample,
    )

    p u.username

    p u.errors.full_messages
  end
  p "There are now #{User.count} users."

  users = User.all

  #Follow Requests 
  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user #if same user go to next set of users 
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end #end of nested loop
  p "There are now #{FollowRequest.count} follow requests."


  users.each do |user|
    #Create photos
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.yoda,
        image: Faker::LoremFlickr.image
      )
      
      #Likes
      user.followers.each do |follower|
        if rand < 0.5 && !photo.fans.include?(follower)
          photo.fans << follower
        end

        #Comments
        if rand < 0.25
          photo.comments.create(
            body: Faker::Quotes::Shakespeare.as_you_like_it_quote,
            author: follower
          )
        end
      end
    end
  end
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
