require 'jwt'

class JsonWebToken
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    # Set verify_expiration to true to avoid raising error on expired token
    if token
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, { verify_expiration: false })
    else
      nil
    end
  end

  def self.valid_payload(payload)
    !(expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud])
  end

  # TODO: improve the meta of the JSON token (iss and aud)
  def self.meta
    {
      exp: 1.day.from_now,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end
