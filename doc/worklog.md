アプリひな形作成

```sh
rails new SubscriptionManagementSystem --no-api --css=bootstrap -m ./apptemplate.rb -d postgresql
```



devices 導入

1. Gemfile に `gem "devise"` を追加
2. `bundle install`
3. `./bin/rails devise:install`
    - 表示されたガイドに従う
4. `./bin/rails generate devise:install`
5. `./bin/rails generate devise:views`


