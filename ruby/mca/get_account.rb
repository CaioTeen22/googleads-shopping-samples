#!/usr/bin/env ruby
# Encoding: utf-8
#
# Copyright:: Copyright 2016, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# Retrieves information about a client account for the specified parent account.

require_relative 'mca_common'

def get_account(content_api, merchant_id, account_id)
  content_api.get_account(merchant_id, account_id) do |res, err|
    if err
      handle_errors(err)
      exit
    end

    puts "Retrieved account ID #{res.id} for MCA #{merchant_id}"
  end
end


if __FILE__ == $0
  unless ARGV.size == 1
    puts "Usage: #{$0} ACCOUNT_ID"
    exit
  end
  account_id = ARGV[0]

  config = Config.load()
  # Account.get can be used in one of two cases:
  # - The requested MCID is the same as the MCID we're using for the call.
  # - The merchant center account is an MCA.
  # The Merchant ID from JSON could be a number instead of a string, but here
  # we check against the string from the command line, so convert
  # the config version to a string for the equality check.
  unless account_id == config.merchant_id.to_s or config.is_mca
    puts "Merchant in configuration is not described as an MCA."
    exit
  end
  content_api = service_setup(config)
  get_account(content_api, config.merchant_id, account_id)
end
