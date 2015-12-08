# DocQuery

Document query interface for plaintext documents stored in directories on a filesystem.

## Installation

```bash
~ $ npm install docquery
...
```

## Usage

### Library

```js
> var dq = new DocQuery("~/Projects/docquery/test/fixtures", {recursive: true})
DocQuery {}

> dq.search("star")
[{"filePath": "/Users/jonmagic/Projects/docquery/test/fixtures/top-5/movies.md",  "fileName": "movies.md",  "title": "movies",  "modifiedAt": "2015-05-15T17:28:25.250Z",  "body": "..."}]

> dq.documents
// [...returns list of all documents sorted newest to oldest]

> dq.on("ready", function() { console.log("fires when documents are finished loading") })
> dq.on("added", function(fileDetails) { console.log("fires when a document is added") })
> dq.on("updated", function(fileDetails) { console.log("fires when a document is updated") })
> dq.on("removed", function(fileDetails) { console.log("fires when a document is removed") })
```

### Command Line

Here's an example directory structure with some markdown documents in it.

```bash
~/Projects/docquery $ tree test/fixtures
test/fixtures
├── 2015-05-15.md
├── hello-world.md
└── top-5
    ├── burgers.md
    └── movies.md

1 directory, 4 files
```

Use the docquery command line tool `dq` to query those documents and get back json results.

```bash
~/Projects/docquery $ dq -r -p test/fixtures star
[
  {
    "filePath": "/Users/jonmagic/Projects/docquery/test/fixtures/top-5/movies.md",
    "fileName": "movies.md",
    "title": "movies",
    "modifiedAt": "2015-05-15T17:28:25.250Z",
    "body": "..."
  }
]
```

`dq` takes a number of options.

```bash
~/Projects/docquery $ dq -h
Usage: dq [options] query

Options:
  -p, --path <path>    Path to search
  -r, --recursive      Search sub directories
  -b, --body           Include document body in search result
  -h, --help           Show dq help
```

Return file paths only from the search results with [`jq`](http://stedolan.github.io/jq/).

```bash
~/Projects/docquery $ dq -rp test/fixtures star | jq .[].filePath
"/Users/jonmagic/Projects/docquery/test/fixtures/top-5/movies.md"
```

Set default options by creating a `~/.dq` file that looks like this:

```json
{
  "recursive": false,
  "searchPath": "~/Notes",
  "includeBody": false
}
```

## Development

```bash
~/Projects/docquery $ npm test

> docquery@1.0.0 test /Users/jonmagic/Projects/docquery
> babel src --out-dir lib; mocha --compilers js:mocha-traceur test/*_test.js

src/cli.js -> lib/cli.js
src/docquery.js -> lib/docquery.js


  DocQuery
    #search
      ✓ returns search result for query (214ms)
      ✓ returns new documents in search results (418ms)
      ✓ does not return document in search results after it has been deleted (626ms)
    #documents
      ✓ returns all documents (209ms)
      ✓ returns documents sorted newest first (210ms)
      ✓ returns new documents as they are added (414ms)
      ✓ does not return document after it has been deleted (625ms)
      ✓ ignores files in subfolders when recursive is false (419ms)


  8 passing (3s)
```

## License

The MIT License (MIT)

Copyright (c) 2015 Jonathan Hoyt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
