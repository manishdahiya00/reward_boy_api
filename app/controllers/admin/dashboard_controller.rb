class Admin::DashboardController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = User.count
    @questions = QuizQuestion.count
    @offers = Offer.count
    @redeems = RedeemRequest.count
  end
end
