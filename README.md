# Chat App

##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 3.0.2
- Rails 7.1.3.4

##### 1. Check out the repository

```bash
git clone git@github.com:CamiloAndresGutierrez/chat-app.git
```

##### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000