module API
  module V1
    class Appuser < Grape::API
      include API::V1::Defaults

      resource :addCoins do
        before { api_params }
        params do
          use :common_params
          requires :coins, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            coins = params[:coins].to_f
            user_balance = user.wallet_balance
            user_coins = coins + user_balance
            user.update(wallet_balance: user_coins)
            { status: 200, message: MSG_SUCCESS }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: addCoins :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :offers do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            offers = []
            all_offers = Offer.active
            all_offers.each do |offer|
              offers << {
                title: offer.title,
                subtitle: offer.subtitle,
                description: offer.description,
                smallImage: offer.small_img_url,
                largeImage: offer.large_img_url,
                amount: offer.amount,
                actionUrl: offer.action_url,
              }
            end
            { status: 200, message: MSG_SUCCESS, offers: offers || [] }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: offers :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :questions do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            questions = []
            all_questions = QuizQuestion.all.order("RANDOM()").order(created_at: :desc).limit(15)
            all_questions.each do |question|
              questions << {
                question: question.question,
                options: [question.option1, question.option2, question.option3, question.option4],
                correctAnswer: question.correct_answer,
              }
            end
            { status: 200, message: MSG_SUCCESS, questions: questions || [] }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: questions :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :payouts do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            payouts = []
            all_payouts = Payout.active
            all_payouts.each do |payout|
              payouts << {
                id: payout.id,
                title: payout.title,
                amounts: payout.amounts,
                image: payout.image,
              }
            end
            { status: 200, message: MSG_SUCCESS, payouts: payouts || [] }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: payouts :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :redeemSubmit do
        before { api_params }
        params do
          use :common_params
          requires :amount, type: String, allow_blank: false
          requires :upiId, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            if user.wallet_balance.to_f >= params[:amount].to_f
              redeem_request = user.redeem_requests.create(upi_id: params[:upiId], amount: params[:amount])
              user.transaction_histories.create(title: "Withdrawl Request", subtitle: redeem_request.status, amount: redeem_request.amount)
              new_balance = user.wallet_balance.to_f - params[:amount].to_f
              user.update(wallet_balance: new_balance)
              { status: 200, message: MSG_SUCCESS, balance: sprintf("%.2f", user.wallet_balance) }
            else
              { status: 500, message: "Not Enough Balance" }
            end
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: redeemSubmit :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :history do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            history = []
            all_history = TransactionHistory.all.order(created_at: :desc).limit(20)
            all_history.each do |his|
              history << {
                title: his.title,
                subtitle: "#{his.created_at.strftime("%d/%m/%Y")} - #{his.subtitle}",
                amount: his.amount,
              }
            end
            { status: 200, message: MSG_SUCCESS, history: history || [] }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: history :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
