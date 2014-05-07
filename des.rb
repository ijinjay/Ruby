require 'openssl'

KEY= 'zycjwdss'
#IV = 'zycjwdss'


PUBLICKEY = '-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBAM1w2GKYGcb1UQwLtRxMCbPFK/hadrrOiJRzeImmTHTnVKL1iftcmPfG
0ATk37x4Qdr7jJ93ZW2u5nKlQoy8jyVUxQjN5DU7jKzUce2Mh+bbZ8pYeLrLF3xj
YUpym+fIA/xt+wf26o0Z/rDvs4IKuANc0hGtK/8R62ne3I2ew89tAgMBAAE=
-----END RSA PUBLIC KEY-----'

PRIVATEKEY = '-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQDNcNhimBnG9VEMC7UcTAmzxSv4Wna6zoiUc3iJpkx051Si9Yn7
XJj3xtAE5N+8eEHa+4yfd2VtruZypUKMvI8lVMUIzeQ1O4ys1HHtjIfm22fKWHi6
yxd8Y2FKcpvnyAP8bfsH9uqNGf6w77OCCrgDXNIRrSv/Eetp3tyNnsPPbQIDAQAB
AoGBAJnVcBKT9mlm9KNieOGRhopYkI5Nny5OzTLsLExWfFXlixjjZ8kTE3AmLUoc
3/RO0HFbf3dBfm/dUa5zVRvxbfWbsoKUt++bNLdXDMG28mOb9CZ+zLNrgzpQ8+0T
M6NIJGNbCWZSY15JBaDUSoCOE4UEbOuGfrlrsvxetCv/eL3BAkEA+GQiFMzV45/s
X1UhoA2bYaIMzv5mukY4XvRKqJh2R9jSWAPa5w84n/prAEEO9cUdaAkGFfTN7Cgw
bZsw8i2YWQJBANO75fx8usDe9MqvbnmTekxWRPySKB6uCJlhMEmLotnYCPvzmcxQ
TcQafH23ziEqbblY+3bHA7AQM0nV9XB0zTUCQDBhaJX+k8ajVqn27fa7z8EDjFUh
DidIGCC+mnAeSiOSYt4L2i5ZM6FNaFwDUAOk4iZqY4oRRa6y4UPoD2+MW/kCQAUp
qbv0VqFpTlK64Fi6jdrap6f48F1/JNqIkiLY8smZCO8Ly449zwefFbYDC1WnsTE5
yDfnNmHOo1GDlA5/6pkCQCWj+YUSwE8GgvjDCCEs6URWiikc/CW/zVYNG9FtzjWu
ZefzMEQdOKz6y8q0OXYBpHX0VpIX5OTImz3SgS4pMaM=
-----END RSA PRIVATE KEY-----'


class Mycipher

  #得出一对RSA密钥
  def self.get_rsa_key
    rsa = OpenSSL::PKey::RSA.new(1024)
# public_key only can public_encrypt or public_decrypt no private_encrypt nor private_decrypt
#rsa.public_key.to_pem the class of return value is String
    [rsa.public_key.to_pem, rsa.to_pem]
  end

  #用私钥加密
  def self.rsa_private_encrypt(value, rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_encrypt(value)
  end

  #用私钥解密 unused
  def self.rsa_private_decrypt(value, rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_decrypt(value)
  end

  #用公钥加密 unused
  def self.rsa_public_encrypt(value, publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_encrypt(value)
  end

  #用公钥解密
  def self.rsa_public_decrypt(value, publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_decrypt(value)
  end

  #DES加密
  def self.des_encrypt(text, key, iv)
    c = OpenSSL::Cipher::Cipher.new('DES-CBC')
    c.encrypt
    c.key = key
    c.iv = iv
    ret = c.update(text)
    ret << c.final
    return ret
  end

  #DES解密
  def self.des_decrypt(encrypt_value, key, iv)
    c = OpenSSL::Cipher::Cipher.new('DES-CBC')
    c.decrypt
    c.key = key
    c.iv = iv
    ret = c.update(encrypt_value)
    ret << c.final
    return ret
  end

  #将文件读为byte型string
  def self.filetostring filepath
    f = File.open filepath, 'rb'
    text = f.read
    f.close
    return text
  end

  #将byte型string转成文件
  def self.stringtofile filepath, string
    f = File.open filepath, 'wb'
    f.print string
    f.close
  end

  #将DES的KEY用RSA私钥加密后转成文件
  def self.keytopefile filepath, key
    pe = rsa_private_encrypt key, PRIVATEKEY
    stringtofile filepath, pe
  end

  #将文件用RSA公钥解密后读出DES的KEY
  def self.pefiletokey filepath
    pe = filetostring filepath
    orikey = rsa_public_decrypt pe, PUBLICKEY
    return orikey
  end

  #加密文件(主要方法)
  def self.encode filepath
    text = filetostring filepath
    en = des_encrypt text, KEY, KEY
    stringtofile filepath, en
    keytopefile filepath + '.pefile', KEY
  end

  #解密文件(主要方法)
  def self.decode filepath
    key = pefiletokey filepath + '.pefile'
    en = filetostring filepath
    text = des_decrypt en, key, key
    stringtofile filepath, text
  end

end

Mycipher.decode 'md5.rb'
