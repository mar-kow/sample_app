require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger', {
      text: 'The form contains 4 errors.'
    }
    assert_select 'div#error_explanation ul li' , {
      text: 'Email is invalid'
    }
    assert_select 'div#error_explanation ul li' , {
      text: "Name can't be blank"
    }
    assert_select 'div#error_explanation ul li' , {
      text: "Password is too short (minimum is 6 characters)"
    }
    assert_select 'div#error_explanation ul li' , {
      text: "Password confirmation doesn't match Password"
    }
    assert_select 'form[action="/signup"]'
  end

  test "invalid signup information - one mistake" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "Test",
                                         email: "user@invalid",
                                         password:              "fooooo",
                                         password_confirmation: "fooooo" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger', {
      text: 'The form contains 1 error.'
    }
    assert_select 'div#error_explanation ul li' , {
      text: 'Email is invalid'
    }
    assert_select 'form[action="/signup"]'
  end
end
