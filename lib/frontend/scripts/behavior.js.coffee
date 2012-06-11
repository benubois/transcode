window.transcode = 
  updateTitles: () ->
    $('.movies').find('li').each (index, movie) ->
      id = $(movie).attr('id')
      $.getJSON("/disc/#{id}", (disc) ->
        $.each(disc.titles, (i, title) ->
          button = $("[data-id='#{id}'][data-title='#{title.title}']", $(movie))
          $(".progress-inner", button).css({width: "#{title.progress}%"})
        )
      )

transcode.init = 
  enqueueTitle: () ->
    $('.movies').on 'click', 'a:not(.selected)', (e) ->
      $(@).addClass('selected')
      params = 
        id: $(@).data('id')
        title: $(@).data('title')
      $.post "/enqueue", params      
      e.preventDefault()
  deleteMovie: () ->
    $('.movies').on 'click', 'button', (e) ->
      form = $(@).parents('form')
      $(@).parents('li').hide('fast', () -> $(@).remove())
      $.ajax
        type: form.attr('method'),
        url: form.attr('action'),
        data: form.serialize(),
      e.preventDefault()
  update: () ->
    window.setInterval(() ->
      transcode.updateTitles()
    , 1000)

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item();
  )