let fs = require("fs")
let tilde = require("tilde-expansion")
let path = require("path")
let lunr = require("lunr")
let chokidar = require("chokidar")
let {EventEmitter} = require("events")

class DocQuery extends EventEmitter {
  constructor(directoryPath, options={}) {
    super()
    this.options = options || {}
    this.options.extensions  = options.extensions || [".md", ".txt"]
    this.options.persistent  = options.persistent == false ? false : true
    this.options.includeBody = options.includeBody == false ? false : true
    this._documents = {}
    this.searchIndex = lunr(function() {
      this.field("title", { boost: 10 })
      this.field("body")
    })
    this.watcher = chokidar.watch(null, {
      depth: this.options.recursive ? undefined : 0,
      persistent: this.options.persistent,
      ignored: (watchedPath, fileStats)=>{
        if(!fileStats) return false
        if(fileStats.isDirectory()) return false
        return !(this.options.extensions.indexOf(path.extname(watchedPath)) > -1)
      }
    })
    var fileDetails = (filePath)=>{
      var fileStats = fs.statSync(filePath)
      var fileName = path.basename(filePath)
      var title = path.basename(fileName, path.extname(fileName))
      var body = fs.readFileSync(filePath, {encoding: "utf8"})

      return {
        filePath: filePath,
        fileName: fileName,
        title: title,
        modifiedAt: fileStats.mtime,
        body: body
      }
    }
    this.watcher.on("add", (filePath)=>{
      this.addDocument(fileDetails(filePath))
    })
    this.watcher.on("change", (filePath)=>{
      this.updateDocument(fileDetails(filePath))
    })
    this.watcher.on("unlink", (filePath)=>{
      this.removeDocument(this._documents[filePath])
    })
    this.watcher.on("ready", ()=>{
      this.emit("ready")
    })
    tilde(directoryPath, (expandedDirectoryPath)=>{
      this.watcher.add(expandedDirectoryPath)
    })
  }

  addDocument(fileDetails) {
    this._documents[fileDetails.filePath] = fileDetails
    this.searchIndex.add({
      id: fileDetails.filePath,
      title: fileDetails.title,
      body: fileDetails.body
    })
    this.emit("added", fileDetails)
  }

  updateDocument(fileDetails) {
    this._documents[fileDetails.filePath] = fileDetails
    this.searchIndex.update({
      id: fileDetails.filePath,
      title: fileDetails.title,
      body: fileDetails.body
    })
    this.emit("updated", fileDetails)
  }

  removeDocument(fileDetails) {
    delete this._documents[fileDetails.filePath]
    this.searchIndex.remove({
      id: fileDetails.filePath,
      title: fileDetails.title,
      body: fileDetails.body
    })
    this.emit("removed", fileDetails)
  }

  search(query) {
    return this.searchIndex.search(query).map((result)=>{
      return this.filterBody(this._documents[result.ref])
    })
  }

  filterBody(doc) {
    var filteredDoc = {}
    for(let key in doc) {
      if(key != "body") {
        filteredDoc[key] = doc[key]
      }else if(this.options.includeBody){
        filteredDoc[key] = doc[key]
      }
    }
    return filteredDoc
  }

  get documents() {
    var documents = []

    for(let key in this._documents) {
      documents.push(this.filterBody(this._documents[key]))
    }

    return documents.sort((a, b)=>{
      if(a.modifiedAt < b.modifiedAt) return 1
      if(a.modifiedAt > b.modifiedAt) return -1
      return 0
    })
  }
}

module.exports = DocQuery
