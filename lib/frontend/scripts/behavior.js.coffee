$(document).ready () ->

  $('.titles').on 'click', 'a:not(.selected)', (e) ->
    clickedButton = $(this)
    params = 
      id: clickedButton.data('id')
      title: clickedButton.data('title')
    $.post "/enqueue", params, (response) ->
      clickedButton.addClass('selected') if response.success is true