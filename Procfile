#web: bundle exec thin start -R config.ru -p $PORT -e $RAILS_ENV
web: bundle exec unicorn -E $RAILS_ENV -p $PORT -c config/unicorn.rb
