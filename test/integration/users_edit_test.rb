require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_response :success
    assert_select "title", "Edit user | Ruby on Rails Tutorial Sample App"
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_response :unprocessable_entity
    assert_select "div.alert", "The form contains 4 errors."
    assert_select "title", "Edit user | Ruby on Rails Tutorial Sample App"
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_response :success
    assert_select "title", "Edit user | Ruby on Rails Tutorial Sample App"
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
