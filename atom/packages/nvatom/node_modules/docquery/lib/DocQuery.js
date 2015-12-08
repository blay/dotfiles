"use strict";

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x2, _x3, _x4) { var _again = true; _function: while (_again) { var object = _x2, property = _x3, receiver = _x4; desc = parent = getter = undefined; _again = false; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x2 = parent; _x3 = property; _x4 = receiver; _again = true; continue _function; } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) subClass.__proto__ = superClass; }

var fs = require("fs");
var tilde = require("tilde-expansion");
var path = require("path");
var lunr = require("lunr");
var chokidar = require("chokidar");

var _require = require("events");

var EventEmitter = _require.EventEmitter;

var DocQuery = (function (_EventEmitter) {
  function DocQuery(directoryPath) {
    var _this = this;

    var options = arguments[1] === undefined ? {} : arguments[1];

    _classCallCheck(this, DocQuery);

    _get(Object.getPrototypeOf(DocQuery.prototype), "constructor", this).call(this);
    this.options = options || {};
    this.options.extensions = options.extensions || [".md", ".txt"];
    this.options.persistent = options.persistent == false ? false : true;
    this.options.includeBody = options.includeBody == false ? false : true;
    this._documents = {};
    this.searchIndex = lunr(function () {
      this.field("title", { boost: 10 });
      this.field("body");
    });
    this.watcher = chokidar.watch(null, {
      depth: this.options.recursive ? undefined : 0,
      persistent: this.options.persistent,
      ignored: function ignored(watchedPath, fileStats) {
        if (!fileStats) return false;
        if (fileStats.isDirectory()) return false;
        return !(_this.options.extensions.indexOf(path.extname(watchedPath)) > -1);
      }
    });
    var fileDetails = function fileDetails(filePath) {
      var fileStats = fs.statSync(filePath);
      var fileName = path.basename(filePath);
      var title = path.basename(fileName, path.extname(fileName));
      var body = fs.readFileSync(filePath, { encoding: "utf8" });

      return {
        filePath: filePath,
        fileName: fileName,
        title: title,
        modifiedAt: fileStats.mtime,
        body: body
      };
    };
    this.watcher.on("add", function (filePath) {
      _this.addDocument(fileDetails(filePath));
    });
    this.watcher.on("change", function (filePath) {
      _this.updateDocument(fileDetails(filePath));
    });
    this.watcher.on("unlink", function (filePath) {
      _this.removeDocument(_this._documents[filePath]);
    });
    this.watcher.on("ready", function () {
      _this.emit("ready");
    });
    tilde(directoryPath, function (expandedDirectoryPath) {
      _this.watcher.add(expandedDirectoryPath);
    });
  }

  _inherits(DocQuery, _EventEmitter);

  _createClass(DocQuery, [{
    key: "addDocument",
    value: function addDocument(fileDetails) {
      this._documents[fileDetails.filePath] = fileDetails;
      this.searchIndex.add({
        id: fileDetails.filePath,
        title: fileDetails.title,
        body: fileDetails.body
      });
      this.emit("added", fileDetails);
    }
  }, {
    key: "updateDocument",
    value: function updateDocument(fileDetails) {
      this._documents[fileDetails.filePath] = fileDetails;
      this.searchIndex.update({
        id: fileDetails.filePath,
        title: fileDetails.title,
        body: fileDetails.body
      });
      this.emit("updated", fileDetails);
    }
  }, {
    key: "removeDocument",
    value: function removeDocument(fileDetails) {
      delete this._documents[fileDetails.filePath];
      this.searchIndex.remove({
        id: fileDetails.filePath,
        title: fileDetails.title,
        body: fileDetails.body
      });
      this.emit("removed", fileDetails);
    }
  }, {
    key: "search",
    value: function search(query) {
      var _this2 = this;

      return this.searchIndex.search(query).map(function (result) {
        return _this2.filterBody(_this2._documents[result.ref]);
      });
    }
  }, {
    key: "filterBody",
    value: function filterBody(doc) {
      var filteredDoc = {};
      for (var key in doc) {
        if (key != "body") {
          filteredDoc[key] = doc[key];
        } else if (this.options.includeBody) {
          filteredDoc[key] = doc[key];
        }
      }
      return filteredDoc;
    }
  }, {
    key: "documents",
    get: function () {
      var documents = [];

      for (var key in this._documents) {
        documents.push(this.filterBody(this._documents[key]));
      }

      return documents.sort(function (a, b) {
        if (a.modifiedAt < b.modifiedAt) return 1;
        if (a.modifiedAt > b.modifiedAt) return -1;
        return 0;
      });
    }
  }]);

  return DocQuery;
})(EventEmitter);

module.exports = DocQuery;