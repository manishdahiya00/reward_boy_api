module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      resource :userSignup do
        before { api_params }

        params do
          requires :deviceId, type: String, allow_blank: false
          requires :deviceType, type: String, allow_blank: true
          requires :deviceName, type: String, allow_blank: false
          requires :socialType, type: String, allow_blank: false
          requires :socialEmail, type: String, allow_blank: false
          requires :socialName, type: String, allow_blank: false
          optional :socialImgUrl, type: String, allow_blank: true
          requires :advertisingId, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
          optional :utmSource, type: String, allow_blank: true
          optional :utmMedium, type: String, allow_blank: true
          optional :utmTerm, type: String, allow_blank: true
          optional :utmContent, type: String, allow_blank: true
          optional :utmCampaign, type: String, allow_blank: true
          optional :referrerUrl, type: String, allow_blank: true
        end

        post do
          begin
            user = User.find_by(social_email: params[:socialEmail])
            if user.present?
              { status: 200, message: MSG_SUCCESS, userId: user.id, securityToken: user.security_token }
            else
              source_ip = request.ip
              new_user = User.create(device_id: params[:deviceId], device_type: params[:deviceType], device_name: params[:deviceName], social_type: params[:socialType], social_email: params[:socialEmail], social_name: params[:socialName], social_img_url: params[:socialImgUrl], advertising_id: params[:advertisingId], version_name: params[:versionName], version_code: params[:versionCode], utm_source: params[:utmSource], utm_term: params[:utmTerm], utm_medium: params[:utmMedium], utm_content: params[:utmContent], utm_campaign: params[:utmCampaign], referrer_url: params[:referrerUrl], source_ip: source_ip, security_token: SecureRandom.uuid, refer_code: SecureRandom.hex(6).upcase)
              { status: 200, message: MSG_SUCCESS, userId: new_user.id, securityToken: new_user.security_token }
            end
          rescue => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: userSignUp :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :defaultUser do
        before { api_params }

        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
          requires :versionName, type: String, allow_blank: false
          requires :versionCode, type: String, allow_blank: false
        end

        post do
          begin
            source_ip = request.ip
            if params[:email] == "testingyash8@gmail.com" && params[:password] == "yash@123"
              user = User.find_by(social_email: params[:email])
              if user.present?
                { message: "Success", status: 200, userId: user.id, securityToken: user.security_token }
              else
                new_user = User.create(social_name: "Testing Yash", social_email: params[:email], security_token: "acc7106fe5009609", source_ip: source_ip, refer_code: SecureRandom.hex(6).upcase, social_img_url: "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")
                { message: "Success", status: 200, userId: new_user.id, securityToken: new_user.security_token }
              end
            else
              { status: 500, message: "Invalid Email Or Password" }
            end
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: defaultUser :::: #{params.inspect} :::: Error - #{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end

      resource :appOpen do
        before { api_params }

        params do
          use :common_params
        end
        post do
          begin
            user = valid_user?(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            source_ip = request.ip
            user.app_opens.create(source_ip: source_ip, version_name: params[:versionName], version_code: params[:versionCode])
          if user.social_img_url.empty?
            image = "http://pluspng.com/img-png/user-png-icon-big-image-png-2240.png"
          else
            image = user.social_img_url
          end
            { status: 200, message: MSG_SUCCESS, walletBalance: sprintf("%.2f", user.wallet_balance), referCode: user.refer_code, name: user.social_name, image: image, email: user.social_email }
          rescue Exception => e
            Rails.logger.info "API Exception :::: #{Time.now} :::: appOpen :::: #{params.inspect} :::: Error ::::#{e}"
            { status: 500, message: MSG_ERROR, error: e.message }
          end
        end
      end
    end
  end
end
