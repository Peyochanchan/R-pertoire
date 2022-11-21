module ControllerMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryBot.create(:user)
    end
  end

  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:user_admin)
    end
  end

  def logout_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_out FactoryBot.create(:user)
    end
  end

  def logout_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_out FactoryBot.create(:user_admin)
    end
  end

  def setup_devise_mapping_user
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def setup_devise_mapping_admin
    @request.env['devise.mapping'] = Devise.mappings[:user_admin]
  end

  def login_with_warden!
    login_as(@user, scope: :user)
  end

  def logout_with_warden!
    logout(:user)
  end

  def login_and_logout_with_devise
    login_user
    yield
    login_user
  end

  def login_and_logout_with_devise_admin
    login_admin
    yield
    logout_admin
  end

  def login_and_logout_with_warden
    Warden.test_mode!
    login_with_warden!
    yield
    logout_with_warden!
    Warden.test_reset!
  end
end
