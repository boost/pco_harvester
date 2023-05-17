Ruby 3.2.2
Rails 7

# Setup

```bash
bundle install
yarn
cp config/application.yml.example config/application.yml
# update the values config/application.yml
bin/rails db:create
bin/rails db:migrate
bin/rails fixtures:load

foreman start -f Procfile.dev
```
