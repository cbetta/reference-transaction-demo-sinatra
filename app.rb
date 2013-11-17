require "sinatra"
require "paypal"

get "/" do
  payment_request = Paypal::Payment::Request.new(
    :billing_type  => :MerchantInitiatedBilling,
    :billing_agreement_description => "My recurring payment"
  )
  response = req.setup(
    payment_request,
    "http://127.0.0.1:4567/success",
    "http://127.0.0.1:4567/cancel"
  )
  response.redirect_uri
end

get "/success" do
  response = req.agree! params["token"]
  billing_agreement_id = response.billing_agreement.identifier
  req.charge! billing_agreement_id, 100
end

def req
  @req ||= begin
    Paypal.sandbox!

    Paypal::Express::Request.new(
      username: "reference_api1.cgb.im",
      password: "1384669463",
      signature: "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AyZ-f8If1xhKIgqGCQ.degtgIKn6"
    )
  end
end