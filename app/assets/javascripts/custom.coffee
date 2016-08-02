$(document).ready ->
  $("#user_avatar").bind "change", ->
    size = @files[0].size / 1024
    if size > 100
      alert "Maximum file size is 100Kb"
