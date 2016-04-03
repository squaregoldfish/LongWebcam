class CameraDetailsController < ApplicationController
    # This controller does not use user security, so there's no session
    skip_before_filter :verify_authenticity_token

    def get_details
        response_code = :ok
        head response_code
    end
end
