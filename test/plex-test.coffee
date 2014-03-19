chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'plex', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/plex')(@robot)

  it 'registers a respond listener for "plex on deck"', ->
    expect(@robot.respond).to.have.been.calledWith(/plex on(\s+)?deck/i)

  it 'registers a respond listener for "plex now playing"', ->
    expect(@robot.respond).to.have.been.calledWith(/plex now(\s+)?playing/i)
