# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#Add default user, so they can access the site
#Only if there are no existing users
if User.count == 0
  User.create!(email: 'admin@admin.com',
               password: 'test1234',
               password_confirmation: 'test1234')
end