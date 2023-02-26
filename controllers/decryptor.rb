require 'openssl'

# Read the encryption's KEY and IV from environment variables
iv = ENV['IV']
key = ENV['KEY']

# Read the facebook app's secret from environment variable
$app_secret = ENV['APP_SECRET']

# check that all the parameters are set
if key.nil? || iv.nil? || $app_secret.nil?
  puts "Error: Missing required environment variable"
  puts "required environment variables are KEY, IV, APP_SECRET"
  exit 1
end

class Decryptor
  def self.init(iv, key)
    @@iv = iv
    @@key = key
  end
  

  def self.decrypt(encrypted_text)
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.key = @@key
    decipher.iv = @@iv
    decrypted = decipher.update([encrypted_text].pack('H*')) + decipher.final
    decrypted.force_encoding('UTF-8')
    JSON.parse(decrypted)
  end
end

Decryptor.init(iv, key)