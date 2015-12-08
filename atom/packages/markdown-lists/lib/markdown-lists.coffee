MarkdownListsView = require './markdown-lists-view'
{CompositeDisposable} = require 'atom'

LIST_UL_REGEX = /// ^ (\s*) ([*+-]) \s+ (.*) $ ///
LIST_OL_REGEX = /// ^ (\s*) (\d+)\. \s+ (.*) $ ///
LIST_TL_REGEX = /// ^ (\s*) (-\ \[[xX\ ]\]) \s+ (.*) $ ///

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor', "markdown-lists:insert-new-line", => @insertNewLine()

  insertNewLine: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.getActivePaneItem()
    line = editor.lineTextForBufferRow(editor.getCursorBufferPosition().row)

    {replaceLine, value} = @_findNewLineValue(line)

    editor.selectToBeginningOfLine() if replaceLine
    editor.insertText(value)

  _findNewLineValue: (line) ->
    if matches = LIST_TL_REGEX.exec(line)
      value = "\n#{matches[1]}- [ ] "
    else if matches = LIST_UL_REGEX.exec(line)
      value = "\n#{matches[1]}#{matches[2]} "
    else if matches = LIST_OL_REGEX.exec(line)
      value = "\n#{matches[1]}#{parseInt(matches[2], 10) + 1}. "

    if matches && !matches[3]
      return replaceLine: true, value: matches[1] || "\n"
    else
      return replaceLine: false, value: value || "\n"
