window.transcode = window.transcode || {}

transcode.setDiscHeight = () ->
  $('.discs li').height(() ->
    $(@).removeAttr('style')
    $(@).css
      height: "#{$(@).height()}px"
  )

transcode.init = 
  nav: () ->
    $('nav a').pjax('.main').on('click', (e) ->
      $('nav li').removeClass('selected')
      $(@).parents('li').addClass('selected')
    )
  
  enqueueTitle: () ->
    $('.discs').on 'click', 'a', (e) ->
      if $(@).not('.selected')
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
  
  unQueue: () ->
    $('.queue li').on 'swipeone click', (e) ->
      $('.unqueue-wrap', @).css(
        width: .001, display: 'block'
      ).animate({
        width: '150px'
      },
        1000
      )

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )