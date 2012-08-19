window.transcode ?= {}

$.extend transcode,
  setRowHeights: () ->
    $('.list li').each () -> 
      $(@).removeAttr('style')
      $(@).css
        height: "#{$(@).height()}px"

  delete: (element) ->
    container = $(element).parents('li')
    if Modernizr.touch
      container.remove()
    else
      container.addClass('animation-delete')
      # Remove element after animation is complete
      window.setTimeout () ->
        container.remove()
      , 300

  hideDelete: (element) ->
    $('.sidebar', element).parents('li').data('state', '')
    $('.sidebar', element).css
      width: '0'

  showDelete: (element) ->
    $('.sidebar').css({width: 0})
    $('.sidebar', element).parents('li').data('state', '')
    $('.sidebar', element).parents('li').data('state', 'open')
    $('.sidebar', element).css
      width: '72px'
    transcode.setRowHeights()

  init: 
    nav: () ->
      $('nav a').pjax('.inner').on 'click', (e) ->
        $('nav li').removeClass('selected')
        $(@).parents('li').addClass('selected')
  
    enqueueTitle: () ->
      $('body').on 'click', '[data-behavior~=enqueue]', (e) ->
        if $(@).hasClass('selected')
          $(@).removeClass('selected')
          $.get $(@).data('unqueue')
        else
          $(@).addClass('selected')
          $.get $(@).data('enqueue')
        e.preventDefault()
  
    deleteMovie: () ->
      $('body').on 'click', '[data-behavior~=delete-disc]', (e) ->
        transcode.delete(@)
        form = $(@).parents('form')
        $.ajax
          type: form.attr('method'),
          url: form.attr('action'),
          data: form.serialize(),
        e.preventDefault()
  
    discHeight: () ->
      transcode.setRowHeights()
      $(window).resize () ->
        transcode.setRowHeights()
  
    unqueue: () ->
      $('body').on 'click', '[data-behavior~=unqueue]', (e) ->
        transcode.delete(@)
        $.get $(@).attr('href')
        false
  
    delete: () ->
      $('body').on 'rightSwipe leftSwipe', '[data-behavior~=swipeable]', (e) ->
        if $(@).data('state') is 'open'
          transcode.hideDelete(@)
        else
          transcode.showDelete(@)
    
      $('.main').on 'click', (e) ->
          transcode.hideDelete(@) if Modernizr.touch
    
    piecon: () ->
      Piecon.setOptions
        color: '#abbdd0',
        background: '#FFF',
        shadow: '#8a9daf',
        fallback: false
        
$(document).ready () ->
  $.each transcode.init, (i, item) ->
    item()
  