# Ruby mock publisher webhooks template
### How to run manually (Ruby required)
bundle install
IV='[IV GOES HERE]' KEY='[KEY GOES HERE]' APP_SECRET=[FACEBOOK APP SECRET] ruby app.rb

### How to build docker image
docker build -t appcharge/webhook-ruby .

### How to run the container locally
docker run -p8080:8080 --rm -it -e KEY='[KEY GOES HERE]' -e IV='[IV GOES HERE]' -e APP_SECRET='[FACEBOOK APP SECRET]' appcharge/webhook-ruby

### Where to get the key
Go to the admin panel, open the integration tab, if you are using signature authentication - copy the key from the primary key field, if you are using encryption, take the key from the primary key field and the IV from the secondary key field.