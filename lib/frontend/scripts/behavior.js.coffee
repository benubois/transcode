window.transcode = window.transcode || {}

transcode.setRowHeights = () ->
  $('.list li').each(() -> 
    $(@).removeAttr('style')
    $(@).css
      height: "#{$(@).height()}px"
  )

transcode.delete = (element) ->
  container = $(element).parents('li')
  container.addClass('animation-delete')
  # Remove element after animation is complete
  window.setTimeout(() ->
    container.remove()
  , 300)

transcode.hideDelete = (element) ->
  $('.sidebar', element).parents('li').removeClass('open')
  $('.sidebar', element).animate({width: '0'}, 300, () -> transcode.setRowHeights())

transcode.showDelete = (element) ->
  $('.sidebar').css({width: 0})
  $('.sidebar').parents('li').removeClass('open')
  $('.sidebar', element).parents('li').addClass('open')
  $('.sidebar', element).animate({ width: '72px' }, 300, () -> transcode.setRowHeights())

transcode.init = 
  nav: () ->
    $('nav a').pjax('.main').on('click', (e) ->
      $('nav li').removeClass('selected')
      $(@).parents('li').addClass('selected')
    )
  
  enqueueTitle: () ->
    $('.main').on 'click', '.enqueue', (e) ->
      if $(@).hasClass('selected')
        $(@).removeClass('selected')
        $.get $(@).data('unqueue')
      else
        $(@).addClass('selected')
        $.get $(@).data('enqueue')
      e.preventDefault()
  
  deleteMovie: () ->
    $('.main').on 'click', '.discs .button-delete', (e) ->
      transcode.delete(@)
      form = $(@).parents('form')
      $.ajax
        type: form.attr('method'),
        url: form.attr('action'),
        data: form.serialize(),
      e.preventDefault()
  
  discHeight: () ->
    transcode.setRowHeights()
    $(window).resize(() ->
      transcode.setRowHeights()
    )
  
  unQueue: () ->
    $('.main').on 'click', '.queue .button-delete', (e) ->
      transcode.delete(@)
      $.get $(@).attr('href')
      false
  
  delete: () ->
    $('.main').on 'swipe', 'li', (e) ->
      if $(@).hasClass('open')
        transcode.hideDelete(@)
      else
        transcode.showDelete(@)
    
    $('.main').on 'click', (e) ->
        transcode.hideDelete(@)
        

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )