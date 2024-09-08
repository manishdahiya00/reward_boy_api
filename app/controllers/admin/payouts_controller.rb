class Admin::PayoutsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @payouts = Payout.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @payout = Payout.find_by(id: params[:id])
  end

  def new
    @payout = Payout.new
  end

  def create
    @payout = Payout.new(payout_params)
    if @payout.save
      redirect_to admin_payouts_path
    else
      render :new
    end
  end

  def edit
    @payout = Payout.find_by(id: params[:id])
  end

  def update
    @payout = Payout.find_by(id: params[:id])
    if @payout.update(payout_params)
      redirect_to admin_payouts_path
    else
      render :edit
    end
  end

  def destroy
    @payout = Payout.find_by(id: params[:id])
    @payout.destroy
    redirect_to admin_payouts_path
  end

  private

  def payout_params
    params.require(:payout).permit(:title, :amounts, :status,:image)
  end
end
