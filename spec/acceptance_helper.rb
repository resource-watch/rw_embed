require 'rails_helper'

def json
  JSON.parse(response.body)['data']
end

def json_attr
  JSON.parse(response.body)['data']['attributes']
end

def json_main
  JSON.parse(response.body)
end