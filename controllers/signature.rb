require 'openssl'

key = ENV['KEY']


class SignatureService

  def self.init(key)
    @@key = key
  end

  def self.get_signature(payload)
    digest = OpenSSL::Digest::SHA256.new
    hmac = OpenSSL::HMAC.digest(digest, @@key, payload)
    signature = hmac.unpack1('H*')
    return signature
  end

  def self.serialize_signature(signature)
    signature_parts = signature.split(",")
    timestamp = signature_parts[0]
    timestamp["t="] = ""
    signature = signature_parts[1]
    signature["v1="] = ""
    return timestamp, signature

  end

  def self.serialize_payload(payload, timestamp)
    serialized_payload = JSON.parse(payload)
    serialized_payload = serialized_payload.to_s
    serialized_payload = serialized_payload.gsub("=>", ":").gsub(" ", "")
    serialized_payload = "%s.%s" % [timestamp, serialized_payload]
    return serialized_payload
  end

  def self.check_signature(payload, signature)
    timestamp, signature = self.serialize_signature(signature)
    serialized_payload = self.serialize_payload(payload, timestamp)
    expected_signature = self.get_signature(serialized_payload)
    return expected_signature == signature
  end

end

SignatureService.init(key)