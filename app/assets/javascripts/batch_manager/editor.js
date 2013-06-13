//= require ./ace/ace
//= require ./ace/mode-ruby
//= require ./ace/theme-tomorrow
//= require ./ace/ext-whitespace

$(function() {
  var editor = ace.edit("editor");
  editor.setTheme("ace/theme/tomorrow");
  editor.getSession().setMode("ace/mode/ruby");
  editor.getSession().setTabSize(2);
  editor.getSession().setUseSoftTabs(true);

  $("form").submit(function() {
    $("#content").val(editor.getValue());
  });
});
