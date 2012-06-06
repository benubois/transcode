$(document).ready () ->

  $('.titles').on 'click', 'a:not(.selected)', (e) ->
    params = 
      id: $(this).data('id')
      title: $(this).data('title')
    $.post "/enqueue", params
