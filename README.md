[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/zeals-co-ltd/makeleaps-ruby.svg?color=green&style=plastic)](https://img.shields.io/github/tag/zeals-co-ltd/makeleaps-ruby.svg?color=green&style=plastic)
[![MIT Licence](https://img.shields.io/github/license/zeals-co-ltd/makeleaps-ruby.svg?style=plastic)](https://img.shields.io/github/license/zeals-co-ltd/makeleaps-ruby.svg?style=plastic)
[![Build Status](https://img.shields.io/travis/com/zeals-co-ltd/makeleaps-ruby/master.svg?style=plastic)](https://img.shields.io/travis/com/zeals-co-ltd/makeleaps-ruby/master.svg?style=plastic)

# Makeleaps Ruby

A simple ruby client for [Makeleaps API](https://app.makeleaps.com/api/docs/).

* Note: this is NOT an official library, but an OSS maintained by third party developers. Please use it as your own risk.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'makeleaps-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install makeleaps-ruby

## Usage

```ruby
require 'makeleaps'

# establish connection using access token
client = Makeleaps::Client.new('your client-id','your client-secret')
client.connect!

# specify your parter_mid (you need to set one to access various resouces)
client.set_partner!(name: 'your_company_name')
```

### Examples

Refer to the [official API document](https://app.makeleaps.com/api/docs/) for detailed API reference.

#### GET (a single instance)

```ruby
client.get '/api/partner/xxxxxxx/document/yyyyyy/'

# below are actually the same request
client.get '/api/partner/xxxxxxx/document/yyyyyy/'                          # direct access (path)
client.get 'https://api.makeleaps.com/api/partner/xxxxxxx/document/yyyyyy/' # direct access (full url)
client.get :document, yyyyy                                                 # endpoints can also be referred as symbols
```
* in the last example, (<partner_mid> is automatically supplied after #set_partner! is invoked

#### GET (a collection)

```ruby
client.get :document # fetching a list of documents
client.get :contact  # fetching a list of contacts

# visiting all pages (following `next` links provided by API)
# (requests are limited at maximum rate of 0.1sec per each)
total_count = 0
client.each_page :document do |documents|
  total_count += documents.count
end

# find a resource (out of all the pages)
client.find_resource(:document) do |document|
  document['title'].match? /URGENT/
end

# find a resource (within a response)
documents = client.get :document
document.find_resource do |document|
  document['document_number'].to_i >= 123 && document['note'].match? /IMPORTANT/
end

# adding a query
documents = client.get :document { |req| req.params['document_number'] = "1000" }
documents = client.get :document { |req| req.params['date__lt'] = "2020-01-30" }
```

#### POST/PATCH/PUT/DELETE

Read the manual carefully before sending a request- it seems API is still beta version, so it might give an unexpected effect on your data when misused. The wrapper gem does not check the validity of the request parameters/payloads.

```ruby
client.post :item, <mid> { |req| req.body = new_item.to_json }

client.patch(:document, <mid>) { |req| req.body = {autocalculate: true, lineitems: updated_items}.to_json }

client.delete :contact, <mid>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/makeleaps-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
