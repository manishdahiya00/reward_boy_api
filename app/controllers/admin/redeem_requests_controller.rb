class Admin::RedeemRequestsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @redeems = RedeemRequest.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def edit
    @redeem = RedeemRequest.find_by(id: params[:id])
  end

  def update
    @redeem = RedeemRequest.find_by(id: params[:id])
    if @redeem.update(redeem_request_params)
      @transaction_history = TransactionHistory.find_by(redeem_request_id: @redeem.id)
      @transaction = @transaction_history.update(subtitle: redeem_request_params[:status])
      redirect_to admin_redeem_requests_path
    else
      render :edit
    end
  end

  def destroy
    @redeem = RedeemRequest.find_by(id: params[:id])
    @redeem.destroy
    redirect_to admin_redeem_requests_path
  end

  private

  def redeem_request_params
    params.require(:redeem_request).permit(:status)
  end
end
