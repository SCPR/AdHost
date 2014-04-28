module AuthenticationHelper
  # For features
  def login(user=nil)
    @user = user || create(:user, password: 'pw')
    visit outpost.login_path

    fill_in "username", with: @user.username
    fill_in "password", with: 'pw'
    click_button "Submit"
    page.should have_content "Logged in."
  end
end
