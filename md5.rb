# md5
require 'digest/md5'
puts Digest::MD5.hexdigest('jinjaysnow')

# sha1
require 'digest/sha1'  
puts Digest::SHA1.hexdigest('jinjaysnow')

# base64
require 'base64'
code = Base64.encode64('jinjaysnow')
source = Base64.decode64(code)
puts code
puts source
