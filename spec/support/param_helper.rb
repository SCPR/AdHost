module ParamHelper
  def public_request_params(params={})
    params.reverse_merge(
      :format       => :json,
      :use_route    => :preroller
    )
  end
end
