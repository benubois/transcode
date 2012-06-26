window.transcode = 
  updateTitles: () ->
    $('.discs').find('li').each (index, movie) ->
      id = $(movie).attr('id')
      $.getJSON("/disc/#{id}", (disc) ->
        $.each(disc.titles, (i, title) ->
          button = $("[data-id='#{id}'][data-title='#{title.title}']", $(movie))
          $(".progress-inner", button).css({width: "#{title.progress}%"})
        )
      )

transcode.init = 
  enqueueTitle: () ->
    $('.discs').on 'click', 'a:not(.selected)', (e) ->
      $(@).addClass('selected')
      params = 
        id: $(@).data('id')
        title: $(@).data('title')
      $.post "/enqueue", params      
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
  # update: () ->
  #   window.setInterval(() ->
  #     transcode.updateTitles()
  #   , 1000)
  discHeight: () ->
    $('.discs li').height(() ->
      $(@).css
        height: "#{$(@).height()}px"
    )

$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )