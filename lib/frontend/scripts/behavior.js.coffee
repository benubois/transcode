window.transcode = window.transcode || {}

transcode.setDiscHeight = () ->
  $('.discs li').height(() ->
    $(@).removeAttr('style')
    $(@).css
      height: "#{$(@).height()}px"
  )

transcode.init = 
  enqueueTitle: () ->
    $('.discs').on 'click', 'a:not(.selected)', (e) ->
      $(@).addClass('selected')
      $.get $(@).attr('href')
      e.preventDefault()
  
  deleteMovie: () ->
    $('.discs').on 'click', 'button', (e) ->
      container = $(@).parents('li')
      container.addClass('animated')
      # Remove element after animation is complete
      window.setTimeout(() ->
        container.remove()
      , 300)
      form = $(@).parents('form')
      $.ajax
        type: form.attr('method'),
        url: form.attr('action'),
        data: form.serialize(),
      e.preventDefault()
  
  discHeight: () ->
    transcode.setDiscHeight()
    $(window).resize(() ->
      transcode.setDiscHeight()
    )
  
$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )