path = require 'path'

ShowTodoView = require '../lib/show-todo-view'
TodosModel = require '../lib/todos-model'

describe "Show Todo View", ->
  [showTodoView, model] = []

  beforeEach ->
    regexes = [
      'TODOs'
      '/\\bTODO:?\\d*($|\\s.*$)/g'
    ]
    atom.config.set 'todo-show.findTheseRegexes', regexes

    atom.project.setPaths [path.join(__dirname, 'fixtures/sample1')]
    model = new TodosModel
    uri = 'atom://todo-show/todos'
    showTodoView = new ShowTodoView(model, uri)
    waitsFor -> !showTodoView.loading

  describe "Basic view properties", ->
    it "has a title, uri, etc.", ->
      expect(showTodoView.getTitle()).toEqual 'Todo-Show Results'
      expect(showTodoView.getIconName()).toEqual 'checklist'
      expect(showTodoView.getURI()).toEqual 'atom://todo-show/todos'
      expect(showTodoView.find('.btn-group')).toExist()

  describe "Automatic update of todos", ->
    it "refreshes on save", ->
      waitsForPromise -> atom.workspace.open 'temp.txt'
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        expect(showTodoView.getTodos()).toHaveLength 3
        editor.setText("# TODO: Test")
        editor.save()

        waitsFor -> !showTodoView.loading
        runs ->
          expect(showTodoView.getTodos()).toHaveLength 4
          editor.setText("")
          editor.save()

          waitsFor -> !showTodoView.loading
          runs ->
            expect(showTodoView.getTodos()).toHaveLength 3

    it "updates on search scope change", ->
      expect(showTodoView.loading).toBe false
      expect(model.getSearchScope()).toBe 'full'
      expect(model.toggleSearchScope()).toBe 'open'
      expect(showTodoView.loading).toBe true

      waitsFor -> !showTodoView.loading
      runs ->
        expect(model.toggleSearchScope()).toBe 'active'
        expect(showTodoView.loading).toBe true

        waitsFor -> !showTodoView.loading
        runs ->
          expect(model.toggleSearchScope()).toBe 'full'
          expect(showTodoView.loading).toBe true

    it "handles search scope; full, open, active", ->
      waitsForPromise ->
        atom.workspace.open 'sample.c'
      runs ->
        pane = atom.workspace.getActivePane()
        expect(showTodoView.getTodos()).toHaveLength 3

        model.setSearchScope 'open'
        waitsFor -> !showTodoView.loading
        runs ->
          expect(showTodoView.getTodos()).toHaveLength 1

          waitsForPromise ->
            atom.workspace.open 'temp.txt'
          runs ->
            model.setSearchScope 'active'
            waitsFor -> !showTodoView.loading
            runs ->
              expect(showTodoView.getTodos()).toHaveLength 0

              pane.activateItemAtIndex 0
              waitsFor -> !showTodoView.loading
              runs ->
                expect(showTodoView.getTodos()).toHaveLength 1
