require 'base64'
require 'json'
require 'pathname'
require 'stringio'
require 'openssl'

def main(args)
  version = 1
  enddt = -1.0
  mxc = args[1]

  message = [enddt].pack("G") + mxc.encode("UTF-8")

  keyfile = Pathname.new(args[0])
  keydata = JSON.parse(keyfile.read)
  key = Base64.urlsafe_decode64(keydata["k"] + '=')
  signature = OpenSSL::HMAC.digest("SHA512", key, message)

  token = [version].pack("C") + signature + message
  puts Base64.urlsafe_encode64(token).gsub("=", "")
end

if __FILE__ == $0
  main(ARGV[0..-1])
end
