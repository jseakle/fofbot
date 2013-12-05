require 'twitter'

Twitter.configure do |config|
  config.consumer_key = "YOUR CONSUMER KEY"
  config.consumer_secret = "YOUR CONSUMER SECRET"
  config.oauth_token = "YOUR OAUTH TOKEN"
  config.oauth_token_secret = "YOUR OAUTH TOKEN SECRET"
end

a = Twitter.friend_ids(YOUR TWITTER USER ID AS AN INTEGER)
friends = a.instance_variable_get("@collection")

friends.delete(YOUR FOFBOT USER ID AS AN INTEGER)

tried = 0
begin
  n = rand(friends.size)
  tried += 1
  fofs = Twitter.friend_ids(friends[n]).instance_variable_get("@collection")
  fofs.delete(YOUR TWITTER USER ID AS AN INTEGER AGAIN)
rescue Twitter::Error
  #puts "failed on #{friends[n]}"
  retry if tried <= 3
  return
end

tried = 0
begin
  n = rand(fofs.size)

  x = 0

  while friends.include? fofs[n] and x < 50 do
    fofs.delete(fofs[n])
    n = rand(fofs.size)
    x += 1
    #puts "Couldn't find an unfollowed FoF in 50 tries"  if x == 49
  end

  tried += 1

  target_tl = Twitter.user_timeline(fofs[n])
  n = rand([20, target_tl.size].min) 
  x = 0

  #This could obviously be smarter by picking without replacement.
  #If you care enough, send me a pull request! :D
  while target_tl[n].instance_variable_get("@attrs")[:retweeted_status] and x < 10 do
    n = rand([20, target_tl.size].min)
    x += 1
    #puts "Found 10 retweets on target FoF's timeline; gave up" if x == 9
  end
  Twitter.retweet(target_tl[n].instance_variable_get("@attrs")[:id_str])
rescue Twitter::Error => e
  #puts "Failed on #{fofs[n]} with message #{e.message}"
  retry if tried <= 3 
end
