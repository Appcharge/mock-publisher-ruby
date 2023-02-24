require 'openssl'

class AESDecryptor
  def initialize(iv, key)
    @iv = iv
    @key = key
  end

  def decrypt(encrypted_text)
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.key = @key
    decipher.iv = @iv
    decrypted = decipher.update([encrypted_text].pack('H*')) + decipher.final
    decrypted.force_encoding('UTF-8')
    JSON.parse(decrypted)
  end
end