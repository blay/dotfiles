let assert = require("assert")
let touch = require("touch")
let DocQuery = require("../lib/DocQuery")
let fs = require("fs")
let delay = function(fn) {
  setTimeout(fn, 205)
}

// Ensure there is a file with a recent timestamp for sorting tests.
touch.sync(`${__dirname}/fixtures/top-5/movies.md`)

describe("DocQuery", ()=>{
  var dq
  var tempFilePath = `${__dirname}/fixtures/tempfile.md`
  var tempSubDirFilePath = `${__dirname}/fixtures/top-5/foo.md`

  beforeEach(()=>{
    dq = new DocQuery("~/Projects/docquery/test/fixtures", {recursive: true})
  })

  afterEach(()=>{
    if(fs.existsSync(tempFilePath)) fs.unlinkSync(tempFilePath)
    if(fs.existsSync(tempSubDirFilePath)) fs.unlinkSync(tempSubDirFilePath)
    dq.watcher.close()
    dq = null
  })

  describe("#search", ()=>{
    it("returns search result for query", (done)=>{
      dq.on("ready", function() {
        var docs = dq.search("star")
        assert.equal(1, docs.length)
        var doc = docs[0]
        assert.equal("/Users/jonmagic/Projects/docquery/test/fixtures/top-5/movies.md", doc.filePath)
        assert.equal("movies.md", doc.fileName)
        assert.equal("movies", doc.title)
        assert.equal("Date", doc.modifiedAt.constructor.name)
        assert.equal(true, doc.body.length > 0)
        done()
      })
    })

    it("returns new documents in search results", (done)=>{
      dq.on("ready", function() {
        dq.on("added", function(fileDetails) {
          var docs = dq.search("temp")
          assert.equal(1, docs.length)
          var doc = docs[0]
          assert.equal("/Users/jonmagic/Projects/docquery/test/fixtures/tempfile.md", doc.filePath)
          assert.equal("tempfile.md", doc.fileName)
          assert.equal("tempfile", doc.title)
          assert.equal("Date", doc.modifiedAt.constructor.name)
          assert.equal("temp file", doc.body)
          done()
        })
        fs.writeFileSync(tempFilePath, "temp file")
      })
    })

    it("does not return document in search results after it has been deleted", (done)=>{
      dq.on("ready", function() {
        assert.equal(0, dq.search("temp").length)
        dq.on("added", function(fileDetails) {
          assert.equal(1, dq.search("temp").length)
          dq.on("removed", function(fileDetails) {
            assert.equal(0, dq.search("temp").length)
            done()
          })
          fs.unlinkSync(tempFilePath)
        })
        fs.writeFileSync(tempFilePath, "hello world")
      })
    })
  })

  describe("#documents", ()=>{
    it("returns all documents", (done)=>{
      dq.on("ready", function() {
        assert.equal(4, dq.documents.length)
        done()
      })
    })

    it("returns documents sorted newest first", (done)=>{
      dq.on("ready", function() {
        assert.equal(true, dq.documents[0].modifiedAt > dq.documents[3].modifiedAt)
        done()
      })
    })

    it("returns new documents as they are added", (done)=>{
      dq.on("ready", function() {
        assert.equal(4, dq.documents.length)
        dq.on("added", function(fileDetails) {
          assert.equal(5, dq.documents.length)
          done()
        })
        fs.writeFileSync(tempFilePath, "hello world")
      })
    })

    it("does not return document after it has been deleted", (done)=>{
      dq.on("ready", function() {
        assert.equal("movies", dq.documents[0].title)
        dq.on("added", function(fileDetails) {
          assert.equal("tempfile", dq.documents[0].title)
          dq.on("removed", function(fileDetails) {
            assert.equal("movies", dq.documents[0].title)
            done()
          })
          fs.unlinkSync(tempFilePath)
        })
        fs.writeFileSync(tempFilePath, "hello world")
      })
    })

    it("ignores files in subfolders when recursive is false", (done)=>{
      var dqNR = new DocQuery("~/Projects/docquery/test/fixtures", {recursive: false})
      dqNR.on("ready", function() {
        assert.equal(2, dqNR.documents.length)
        fs.writeFileSync(tempSubDirFilePath, "hello world")
        delay(()=>{
          assert.equal(2, dqNR.documents.length)
          done()
        })
      })
    })
  })
})
