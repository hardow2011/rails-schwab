class UsersController < ApplicationController
  # before_action :set_user, only: %i[ edit update destroy ]
  skip_before_action :authenticate_request!, only: [:new, :create, :login]
  before_action :redirect_to_root_of_logged_in, only: [:login, :new]

  # GET /users or /users.json
  # def index
  #   @current_users = User.all
  # end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @redirect_path = params[:redirect_path]
    @submit_msg = 'Sign Up'
    @alternate_link = login_path
    @alternate_txt = 'Already registered? Login here'
  end

  def login
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
    if params[:csv]
      uploaded_file = params[:csv][0]
      @current_user.set_transactions(uploaded_file)
      flash[:success] = ["Successfully uploaded #{@current_user.transactions.length} transactions."]
      redirect_to user_url
      return
    else
      flash[:errors] = { csv: ['Transactions CSV can\'t be blank.'] }
      redirect_to user_url
    end
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
    @current_user = User.new(user_params)

    respond_to do |format|
      if @current_user.save
        session[:user_id] = @current_user.id
        format.html { redirect_to root_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @current_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def request_email_change
    # byebug
    @current_user.request_email_change
    flash[:success] = ["Follow the instructions sent to your mailbox to change your email."]
    redirect_to user_url
  end

  def update_email
    email_change_token = params[:email_change_token]
    decoded_token = JsonWebToken.decode(email_change_token)

    unless decoded_token and User.where(email_change_token: email_change_token).exists? and JsonWebToken.valid_payload(decoded_token.first)
      flash[:alert] = ['Expired or Invalid session']
      redirect_to root_path
      return
    end

    new_email = user_params[:new_email].strip
    new_email_confirmation = user_params[:new_email_confirmation].strip

    if new_email == new_email_confirmation
      if new_email.blank?
        flash[:errors] = ['Emails can\'t be empty.']
        redirect_to change_email_path(email_change_token: email_change_token)
      elsif new_email == @current_user.email
        flash[:errors] = ['New email cannot be the same as the current one']
        redirect_to change_email_path(email_change_token: email_change_token)
      elsif User.email_taken?(new_email)
        flash[:errors] = ['Email already taken.']
        redirect_to change_email_path(email_change_token: email_change_token)
      else
        #   TODO: send email to new email to confirm
        @current_user.update_email(new_email)
        flash[:success] = ["Check #{new_email} inbox to finalize the email change."]
        redirect_to user_path
      end
    else
      flash[:errors] = ['Emails must match.']
      redirect_to change_email_path(email_change_token: email_change_token)
    end
  end

  def confirm_email_update
    email_update_token = params[:email_update_token]
    decoded_token = JsonWebToken.decode(email_update_token)

    if decoded_token && decoded_token.first['new_email'].present? && User.where(email_change_token: email_update_token).exists? && JsonWebToken.valid_payload(decoded_token.first)
      new_email = decoded_token.first['new_email']
      @current_user.confirm_email_update(new_email)
      session[:auth_token] = @current_user.generate_auth_token
      flash[:success] = ["Email updated successfully."]
      redirect_to root_path
      return
    end

    flash[:alert] = ['Expired or Invalid session']
    redirect_to root_path
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @current_user.update(user_params)
        flash[:success] = ["User was successfully updated."]
        format.html { redirect_to user_url }
        format.json { render :show, status: :ok, location: @current_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @current_user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def transactions
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_user
  #   @current_user = User.find(params[:id])
  # end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :new_email, :new_email_confirmation)
  end
end
