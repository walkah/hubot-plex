# Description:
#   Interaction with a plex media server
#
# Configuration
#   HUBOT_PLEX_URL - URL to your plex media server (e.g. http://localhost:32400)
#   HUBOT_PLEX_TOKEN - For remote access (X-Plex-Token value)
# 
# Commands:
#   hubot plex on deck - show all videos that are "on deck"
#   hubot plex now playing - show what is currently playing 
# 
# Author
#   walkah

module.exports = (robot) ->
  robot.respond /plex on(\s+)?deck/i, (msg) ->
    PlexAPI msg, 'library/onDeck', (data) ->
      for video in data['_children']
        # console.log video
        if video['type'] == 'episode'
          show = 
          s = String('00' + video['parentIndex']).slice(-2)
          e = String('00' + video['index']).slice(-2)
          msg.send "#{video['grandparentTitle']} - #{video['title']} (S#{s}E#{e})"
        else if video['type'] == 'movie'
          msg.send "#{video['title']} (#{video['year']})"

  robot.respond /plex now(\s+)?playing/i, (msg) ->
    PlexAPI msg, 'status/sessions', (data) ->
      for video in data['_children']
        for child in video['_children'] 
          if child['_elementType'] == 'User'
            user = child
          else if child['_elementType'] == 'Player'
            player = child
        msg.send "#{video['title']} by #{user['title']} on #{player['title']}"
        
PlexAPI = (msg, query, cb) ->
  plex_url = process.env.HUBOT_PLEX_URL
  
  msg.http("#{plex_url}/#{query}")
    .headers(getHeaders())
    .get() (err, res, body) ->
      data = JSON.parse(body)
      cb data

getHeaders = ->
  plex_token = process.env.HUBOT_PLEX_TOKEN

  headers = 'Accept': "application/json"
  if plex_token
    headers["X-Plex-Token"] = plex_token

  return headers
