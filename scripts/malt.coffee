# Description
#   Lists what beers are available on tap at a few of Wellington's Pubs
#
# Dependencies:
#   "scraper": "0.0.7"
#
# Configuration:
#   NONE
#
# Commands:
#   hubot what's on tap at /pub/ - returns a list of beers on tap at /pub/
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

request = require('request')
_       = require('lodash')

pubs =
  'hashigo': 1
  'lbq': 2
  'vagabond': 3
  'socro': 4
  'greenman': 5
  'fork&brewer': 6
  'malthouse': 7
  'bin44': 8
  'd4': 9
  'hopgarden': 10
  'establishment': 11
  'bruhaus': 12
  'brew-on-quay': 13

module.exports = (robot) ->
  robot.hear /.*(whats on tap at)(.*)/i, (msg) ->
    pub = msg.match[2].trim()

    unless pubs.hasOwnProperty(pub)
      msg.send "Please select from one of the following pubs #{Object.keys(pubs).join(', ')}"

    url = "http://maltlist.com/api/products.json?local_business_id=#{pubs[pub]}"
    beers = []

    request url, (error, response, body) ->

      if !error and response.statusCode == 200
        info = JSON.parse(body)
        for beer in info.data
          for offer in beer.offers
            if offer.category == 'tap'
              beers.push "#{beer.name} #{beer.abv}%" unless beer.name == 'On the Hand-pull'

      msg.send  _.unique(beers).join('\n')