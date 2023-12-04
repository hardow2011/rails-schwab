class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]
  skip_before_action :authenticate_request!, only: [:new, :create, :login]
  before_action :redirect_to_root_of_logged_in, only: [:login, :new]

  # GET /users or /users.json
  # def index
  #   @users = User.all
  # end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @redirect_path = params[:redirect_path]
    @submit_msg = 'Sign up'
    @alternate_link = login_path
    @alternate_txt = 'Already registered? Login here'
  end

  def login
    # TODO: implement redirect path
    @role = :login
    @redirect_path = params[:redirect_path]
    @submit_msg = 'Log In'
    @alternate_link = signup_path
    @alternate_txt = 'Not registered yet? Signup here'
  end

  # GET /users/1/edit
  def edit
  end

  def transactions_csv
    uploaded_file = params[:csv].values[0]
    current_user.set_transactions(uploaded_file)
    redirect_to user_url
  end

  def transactions_json
    chart_data = @current_user.get_transactions_chart_data
    total_value = JSON.parse(chart_data).empty? ? '0' : JSON.parse(chart_data).last["running_balance"]
    respond_to do |format|
      format.json { render json: { chart_data: chart_data, total_value: total_value }, status: :ok }
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def transactions
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
