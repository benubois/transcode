$(document).ready () ->
  
  $('.movies').on 'click', 'a:not(.selected)', (e) ->
    $(@).addClass('selected')
    params = 
      id: $(@).data('id')
      title: $(@).data('title')
    $.post "/enqueue", params      
    e.preventDefault()
  
  $('.movies').on 'click', 'button', (e) ->
    form = $(@).parents('form')
    $(@).parents('li').hide('fast', () -> $(@).remove())
    $.ajax
      type: form.attr('method'),
      url: form.attr('action'),
      data: form.serialize(),
    e.preventDefault()