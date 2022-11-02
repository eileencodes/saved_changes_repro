# README

To demo the bug that was revealed by https://github.com/rails/rails/pull/46282.

Steps to repro;

* Clone the repo
* Run `bundle`
* Run `bin/rails db:migrate`
* Run `bin/rails test/models/post_test.rb`

Failure:

```
Failure:
PostTest#test_saved_changed [/Users/eileencodes/src/github.com/Shopify/rails_apps/saved_changes_repro/test/models/post_test.rb:7]:
Expected {"title"=>["MyString", "hello!"], "updated_at"=>[Wed, 02 Nov 2022 21:14:40.966188000 UTC +00:00, Wed, 02 Nov 2022 21:14:40.978256000 UTC +00:00]} to be empty.
```

Test should pass. There's an interaction between the default attributes set by `activerecord-typestore` and the cahnges in this Rails PR.
