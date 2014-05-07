require 'digest/md5'
puts Digest::MD5.hexdigest('jinjaysnow')

# base64
require 'base64'
code = Base64.encode64('jinjaysnow')
source = Base64.decode64(code)
puts code
puts source
