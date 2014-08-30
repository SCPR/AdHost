require "spec_helper"

# We have to copy this from shared resource controller specs because our
# assertions are a little bit different.
describe Outpost::UsersController do
  let(:resource) { :user }

  before :each do
    @user           = create :user
    @current_user   = create :user, is_superuser: false
    controller.stub(:current_user) { @current_user }
  end


  let(:user) { create :user, name: "Mr. Nobody" }

  let(:valid_params) do
    build(:user).attributes
      .slice(*%w(name email username))
  end

  context "without proper permission" do
    describe 'GET /index' do
      it "redirects to outpost root" do
        get :index
        response.should redirect_to "/outpost/"
      end
    end

    describe 'GET /show' do
      it "redirects to outpost root" do
        get :show, id: @user.id
        response.should redirect_to "/outpost/"
      end
    end

    describe 'GET /edit' do
      it "redirects to outpost root" do
        get :edit, id: @user.id
        response.should redirect_to "/outpost/"
      end
    end

    describe 'POST /create' do
      it "redirects to outpost root" do
        post :create, user: { who: "cares" }
        response.should redirect_to "/outpost/"
      end
    end

    describe 'PUT /update' do
      it "redirects to outpost root" do
        put :update, id: @user.id, user: { who: "cares" }
        response.should redirect_to "/outpost/"
      end
    end

    describe 'DELETE /destroy' do
      it "redirects to outpost root" do
        delete :destroy, id: @user.id
        response.should redirect_to "/outpost/"
      end
    end
  end


  context "with proper permissions" do
    before :each do
      @current_user.permissions <<
        Permission.find_by_resource(@user.class.name)
    end

    describe "GET /index" do
      it "responds with success" do
        get :index
        assigns(:records).should eq [@user, @current_user]
        response.should be_success
      end
    end

    describe "GET /show" do
      it "redirects to edit" do
        get :show, id: @user.id
        assigns(:record).should eq @user
        response.should redirect_to @user.admin_edit_path
      end
    end

    describe "GET /new" do
      it "responds with success" do
        get :new
        response.should be_success
      end
    end

    describe "GET /edit" do
      it "responds with success" do
        get :edit, id: @user.id
        assigns(:record).should eq @user
        response.should be_success
      end
    end

    describe "POST /create" do
      it "creates the resource" do
        expect {
          post :create, user: valid_params
            .merge(
              "password" => "secret",
              "password_confirmation" => "secret"
            )
        }.to change { User.count }.by(1)

        # Redirect to index path because there is no commit_action parameter,
        # so it uses index path which is fallback.
        response.should redirect_to User.admin_index_path
      end
    end

    describe "PUT /update" do
      it "updates the record" do
        @user.update_column(:updated_at, 1.day.ago)

        expect {
          put :update,
            :id         => @user.id,
            :user       => { name: "Bricker" }
        }.to change { @user.reload.updated_at }

        assigns(:record).should eq @user
        response.should redirect_to @user.class.admin_index_path
      end
    end

    describe "DELETE /destroy" do
      it "destroys the resource" do
        delete :destroy, id: @user.id
        assigns(:record).should eq @user
        response.should be_redirect
      end
    end
  end


  context "as the same user" do
    describe "GET /show" do
      it "redirects to edit" do
        get :show, id: @current_user.id
        assigns(:record).should eq @current_user
        response.should redirect_to @current_user.admin_edit_path
      end
    end

    describe "GET /edit" do
      it "responds with success" do
        get :edit, id: @current_user.id
        assigns(:record).should eq @current_user
        response.should be_success
      end
    end

    describe "PUT /update" do
      it "updates the record" do
        @current_user.update_column(:updated_at, 1.day.ago)

        expect {
          put :update,
            :id         => @current_user.id,
            :user       => { name: "Bricker" }
        }.to change { @current_user.reload.updated_at }

        assigns(:record).should eq @current_user
        response.should redirect_to @current_user.class.admin_index_path
      end
    end

    describe "DELETE /destroy" do
      it "destroys the resource" do
        delete :destroy, id: @current_user.id
        User.find(@current_user.id).should_not be_destroyed

        response.should be_redirect
      end
    end
  end

  context 'as admin' do
    before do
      @current_user.update_attribute(:is_superuser, true)
    end

    describe 'update attributes' do
      it 'can update admin attributes' do
        @user.update_attribute(:is_superuser, false)

        expect {
          put :update,
            :id         => @user.id,
            :user       => { is_superuser: true }
        }.to change { @user.reload.is_superuser }
      end
    end
  end
end
