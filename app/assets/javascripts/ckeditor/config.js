CKEDITOR.editorConfig = function (config) {

  config.toolbar_mini = [
    ['Format', '-', "Bold",  "Italic",  "Underline", 'Link', 'NumberedList', 'BulletedList',  'Blockquote', '-', 'Cut', 'Undo', 'Redo'],
  ];
  config.toolbar = "mini";
  config.removePlugins = 'elementspath';
}