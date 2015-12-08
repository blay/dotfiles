#! /usr/bin/env node

let argvParser = require("minimist")
let argv = argvParser(process.argv.slice(2), {
  boolean: ["r", "b", "h"],
  alias: {
    r: "recursive",
    b: "body",
    h: "help",
    p: "path"
  }
})
let printLine = function(text) {
  console.log(text)
}

if(argv.h) {
  printLine("Usage: dq [options] query")
  printLine(" ")
  printLine("Options:")
  printLine("  -p, --path <path>    Path to search")
  printLine("  -r, --recursive      Search sub directories")
  printLine("  -b, --body           Include document body in search result")
  printLine("  -h, --help           Show dq help")
  process.exit(0)
}

let fs = require("fs")
let tilde = require("tilde-expansion")
let DocQuery = require("./DocQuery")
let delay = function(fn) {
  setTimeout(fn, 500)
}

// Read default options from ~/.dq
let defaultOptions = {}
tilde("~/.dq", function(path) {
  if(fs.existsSync(path)) {
    defaultOptions = JSON.parse(fs.readFileSync(path, {encoding: "utf8"}))
  }
})

let options = {
  recursive: false,
  includeBody: false
}

// Should dq search sub directories?
if(argv.r) {
  options.recursive = true
}else if(defaultOptions.hasOwnProperty("recursive")) {
  options.recursive = defaultOptions.recursive
}else{
  options.recursive = false
}

// Should search result include body?
if(argv.b) {
  options.includeBody = true
}else if(defaultOptions.hasOwnProperty("includeBody")) {
  options.includeBody = defaultOptions.includeBody
}else{
  options.includeBody = false
}

// Use path from args first, configured default second, or current path last.
let execPath = argv.p
if(!execPath) execPath = defaultOptions.searchPath
if(!execPath) execPath = process.cwd

// Create the DocQuery instance.
let dq = new DocQuery(execPath, options)

// Pause before running the query to ensure data has been indexed.
delay(function() {
  let results = dq.search(argv._.join(" "))
  let output = JSON.stringify(results, null, 2)
  printLine(output)
  dq.watcher.close()
})
