#! /usr/bin/env node
"use strict";

var argvParser = require("minimist");
var argv = argvParser(process.argv.slice(2), {
  boolean: ["r", "b", "h"],
  alias: {
    r: "recursive",
    b: "body",
    h: "help",
    p: "path"
  }
});
var printLine = function printLine(text) {
  console.log(text);
};

if (argv.h) {
  printLine("Usage: dq [options] query");
  printLine(" ");
  printLine("Options:");
  printLine("  -p, --path <path>    Path to search");
  printLine("  -r, --recursive      Search sub directories");
  printLine("  -b, --body           Include document body in search result");
  printLine("  -h, --help           Show dq help");
  process.exit(0);
}

var fs = require("fs");
var tilde = require("tilde-expansion");
var DocQuery = require("./DocQuery");
var delay = function delay(fn) {
  setTimeout(fn, 500);
};

// Read default options from ~/.dq
var defaultOptions = {};
tilde("~/.dq", function (path) {
  if (fs.existsSync(path)) {
    defaultOptions = JSON.parse(fs.readFileSync(path, { encoding: "utf8" }));
  }
});

var options = {
  recursive: false,
  includeBody: false
};

// Should dq search sub directories?
if (argv.r) {
  options.recursive = true;
} else if (defaultOptions.hasOwnProperty("recursive")) {
  options.recursive = defaultOptions.recursive;
} else {
  options.recursive = false;
}

// Should search result include body?
if (argv.b) {
  options.includeBody = true;
} else if (defaultOptions.hasOwnProperty("includeBody")) {
  options.includeBody = defaultOptions.includeBody;
} else {
  options.includeBody = false;
}

// Use path from args first, configured default second, or current path last.
var execPath = argv.p;
if (!execPath) execPath = defaultOptions.searchPath;
if (!execPath) execPath = process.cwd;

// Create the DocQuery instance.
var dq = new DocQuery(execPath, options);

// Pause before running the query to ensure data has been indexed.
delay(function () {
  var results = dq.search(argv._.join(" "));
  var output = JSON.stringify(results, null, 2);
  printLine(output);
  dq.watcher.close();
});