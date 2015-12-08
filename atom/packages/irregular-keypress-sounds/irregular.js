var path = require("path");
var pressed = {};

function handleKeyDown(event) {
	if (!pressed[event.keyCode]) {
		pressed[event.keyCode] = true;

		var randSound = "audio/key" + Math.ceil(Math.random()*36) + ".mp3";
		var key_down = new Audio(path.join(__dirname, randSound));
		key_down.play();
	}
}

function handleKeyUp(event) {
		pressed[event.keyCode] = false;
}

module.exports = {
	activate: function(state) {
		atom.workspace.observeTextEditors(function(editor) {
			var editorView = atom.views.getView(editor);

			editorView.addEventListener('keydown', handleKeyDown);
			editorView.addEventListener('keyup', handleKeyUp);
		});
	},

	deactivate: function () {
		atom.workspace.observeTextEditors(function(editor) {
			var editorView = atom.views.getView(editor);

			editorView.removeEventListener('keydown', handleKeyDown);
			editorView.removeEventListener('keyup', handleKeyUp);
		});
	}
};
