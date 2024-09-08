class Admin::OffersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @offers = Offer.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @offer = Offer.find_by(id: params[:id])
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path
    else
      render :new
    end
  end

  def edit
    @offer = Offer.find_by(id: params[:id])
  end

  def update
    @offer = Offer.find_by(id: params[:id])
    if @offer.update(offer_params)
      redirect_to admin_offers_path
    else
      render :edit
    end
  end

  def destroy
    @offer = Offer.find_by(id: params[:id])
    @offer.destroy
    redirect_to admin_offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:title, :subtitle, :description, :amount, :small_img_url, :large_img_url, :status,:action_url)
  end
end
