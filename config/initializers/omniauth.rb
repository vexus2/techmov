Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,"LTE9cmvCb0joicGXR43RA","bAAC6AsLZaaFf4ISRIeAAIZBeFET7Oth6G727uVAo"
  provider :facebook,"App ID","App Secret"
end