require 'es6-shim'
proxyquire = require 'proxyquire'
chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chaiAsPromised = require "chai-as-promised"

chai.should()
chai.use sinonChai
chai.use chaiAsPromised

describe 'Lookup Wallet Journal', ->
  expected =
    entries: [
      {
        "date": "2010-12-10 06:32:00",
        "refID": 3605306236,
        "refTypeID": 72,
        "ownerName1": "corpslave12",
        "ownerID1": 150337897,
        "ownerName2": "Secure Commerce Commission",
        "ownerID2": 1000132,
        "argName1": 35402980,
        "argID1": "0",
        "amount": -10000.00,
        "balance": 985580165.53,
        "reason": "",
        "taxReceiverID": "",
        "taxAmount": ""
      },
      {
        "date": "2010-12-10 06:32:00",
        "refID": 3605305292,
        "refTypeID": 72,
        "ownerName1": "corpslave12",
        "ownerID1": 150337897,
        "ownerName2": "Secure Commerce Commission",
        "ownerID2": 1000132,
        "argName1": 35402974,
        "argID1": "0",
        "amount": -10000.00,
        "balance": 985590165.53,
        "reason": "",
        "taxReceiverID": "",
        "taxAmount": ""
      },
      {
        "date": "2010-12-10 06:31:00",
        "refID": 3605303380,
        "refTypeID": 72,
        "ownerName1": "corpslave12",
        "ownerID1": 150337897,
        "ownerName2": "Secure Commerce Commission",
        "ownerID2": 1000132,
        "argName1": 35402956,
        "argID1": "0",
        "amount": -10000.00,
        "balance": 985600165.53,
        "reason": "",
        "taxReceiverID": "",
        "taxAmount": ""
      },
      {
        "date": "2010-12-10 06:30:00",
        "refID": 3605302609,
        "refTypeID": 72,
        "ownerName1": "corpslave12",
        "ownerID1": 150337897,
        "ownerName2": "Secure Commerce Commission",
        "ownerID2": 1000132,
        "argName1": 35402950,
        "argID1": "0",
        "amount": -10000.00,
        "balance": 985610165.53,
        "reason": "",
        "taxReceiverID": "",
        "taxAmount": ""
      },
      {
        "date": "2010-12-10 06:30:00",
        "refID": 3605301231,
        "refTypeID": 72,
        "ownerName1": "corpslave12",
        "ownerID1": 150337897,
        "ownerName2": "Secure Commerce Commission",
        "ownerID2": 1000132,
        "argName1": 35402941,
        "argID1": "0",
        "amount": -10000.00,
        "balance": 985620165.53,
        "reason": "",
        "taxReceiverID": "",
        "taxAmount": ""
      }
    ]

  params =
    keyID:
      '13434'
    vCode:
      'kjakfjoqwuer08903481094qjfkladjffi9198'
    characterID:
      '245564'

  it 'Single Response', ->
    neow =
      EveClient: ->
        fetch: sinon.stub().returns Promise.resolve expected
    journal = proxyquire '../../data/journal', 'neow': neow

    journal.load(params).should.eventually.be.eql expected.entries

  it 'Multiple Response', ->
    fetch = sinon.stub()

    fetch.onCall(0).returns Promise.resolve entries: expected.entries[..2]
    fetch.onCall(1).returns Promise.resolve entries: expected.entries[3..]

    neow =
      EveClient: ->
        fetch: fetch
    journal = proxyquire '../../data/journal', 'neow': neow

    params.rowCount = 3
    journal.load(params).should.eventually.be.eql expected.entries