include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def invalid_signin
  click_button "Sign in"
end

def signout
  click_link "Sign out"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_banner do |h1, title|
  match do |page|
    page.should have_selector('h1',    text: h1)
    page.should have_selector('title', text: title)
  end
end
