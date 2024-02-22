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
end
