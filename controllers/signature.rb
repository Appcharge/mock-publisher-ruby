require 'openssl'
require 'json'

key = ENV['KEY']

if key.nil?
  puts "Error: Missing required environment variable"
  puts "required environment variables is KEY"
  exit 1
end

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

  def self.parse_signature(signature)
    regex = /t=(.*),v1=(.*)/
    match = regex.match(signature)
    unless match && match.size >= 3
      raise ArgumentError, "Invalid signature format"
    end
    timestamp = match[1]
    signature = match[2]
    return timestamp, signature

  end

  def self.serialize_payload(payload, timestamp)
    payload_hashmap = JSON.parse(payload)
    formatted_payload = JSON.generate(payload_hashmap, space: "").to_s
    serialized_payload = "%s.%s" % [timestamp, formatted_payload]
    return serialized_payload
  end

  def self.check_signature(payload, signature)
    timestamp, signature = self.parse_signature(signature)
    serialized_payload = self.serialize_payload(payload, timestamp)
    expected_signature = self.get_signature(serialized_payload)
    return expected_signature == signature
  end

end

SignatureService.init(key)
