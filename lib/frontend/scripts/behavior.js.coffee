window.transcode = {}

transcode.init = 
  enqueueTitle: () ->
    $('.discs').on 'click', 'a:not(.selected)', (e) ->
      $(@).addClass('selected')
      $.get $(@).attr('href')
      e.preventDefault()
  deleteMovie: () ->
    $('.discs').on 'click', 'button', (e) ->
      form = $(@).parents('form')
      container = $(@).parents('li')
      container.addClass('animated')
      
      # Remove element after animation is complete
      window.setTimeout(() ->
        container.remove()
      , 300)
      
      $.ajax
        type: form.attr('method'),
        url: form.attr('action'),
        data: form.serialize(),
      e.preventDefault()
  discHeight: () ->
    $('.discs li').height(() ->
      $(@).css
        height: "#{$(@).height()}px"
    )

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )