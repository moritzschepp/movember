json.array! @users do |user|
  json.id user.id
  json.email user.email
  json.amount user.amount_paid
  json.cart user.cart
  json.admin user.admin?
  json.url user_url(user)
  json.edit_url edit_user_url(user)
  json.auth_url authenticate_url(:credentials => {:token => user.token})
end