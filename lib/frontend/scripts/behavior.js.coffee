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
  $('.sidebar', element).parents('li').data('state', '')
  $('.sidebar', element).animate({width: '0'}, 300, () -> transcode.setRowHeights())

transcode.showDelete = (element) ->
  $('.sidebar').css({width: 0})
  $('.sidebar', element).parents('li').data('state', '')
  $('.sidebar', element).parents('li').data('state', 'open')
  $('.sidebar', element).animate({ width: '72px' }, 300, () -> transcode.setRowHeights())

transcode.init = 
  nav: () ->
    $('nav a').pjax('.main').on('click', (e) ->
      $('nav li').removeClass('selected')
      $(@).parents('li').addClass('selected')
    )
  
  enqueueTitle: () ->
    $('body').on 'click', '[data-behavior="enqueue"]', (e) ->
      if $(@).hasClass('selected')
        $(@).removeClass('selected')
        $.get $(@).data('unqueue')
      else
        $(@).addClass('selected')
        $.get $(@).data('enqueue')
      e.preventDefault()
  
  deleteMovie: () ->
    $('body').on 'click', '[data-behavior="delete-disc"]', (e) ->
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
  
  unqueue: () ->
    $('body').on 'click', '[data-behavior="unqueue"]', (e) ->
      transcode.delete(@)
      $.get $(@).attr('href')
      false
  
  delete: () ->
    $('body').on 'rightSwipe leftSwipe', '[data-behavior="swipeable"]', (e) ->
      if $(@).data('state') is 'open'
        transcode.hideDelete(@)
      else
        transcode.showDelete(@)
    
    $('.main').on 'click', (e) ->
        transcode.hideDelete(@)
        

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )