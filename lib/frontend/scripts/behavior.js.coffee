window.transcode = window.transcode || {}

transcode.setDiscHeight = () ->
  $('.discs li').height(() ->
    $(@).removeAttr('style')
    $(@).css
      height: "#{$(@).height()}px"
  )

transcode.progressCircle = (id, percent) ->
  canvas = document.getElementById(id)
  ctx = canvas.getContext("2d")
  
  canvas.width = canvas.width * window.devicePixelRatio
  canvas.height = canvas.height * window.devicePixelRatio
  
  gradient = ctx.createLinearGradient(0,0,0,canvas.width)  
  gradient.addColorStop(0, '#bfccdb')  
  gradient.addColorStop(1, '#a4b8cc') 
        
  colors = [gradient, "#FFF"]
  data = [percent, 100 - percent]

  lastend = 0
  total = 100

  mid_x = canvas.width / 2
  mid_y = canvas.height / 2
        
  ctx.clearRect(0, 0, canvas.width, canvas.height)
        
  for i in [0..data.length]
    ctx.fillStyle = colors[i]
    ctx.beginPath()
    ctx.moveTo(mid_x, mid_y)
    ctx.arc(mid_x, mid_y, mid_x, lastend, lastend + (Math.PI*2*(data[i]/total)), false)
    ctx.lineTo(mid_x, mid_y)
    ctx.fill()
    lastend += Math.PI * 2 * (data[i]/total)

        
  strokeWidth = 1
  ctx.beginPath()
  ctx.arc(mid_x, mid_y, mid_x - .5, 0, 2 * Math.PI, false)
  ctx.lineWidth = strokeWidth
  ctx.strokeStyle = "#99a9ba"
  ctx.stroke()
  ctx.scale(window.devicePixelRatio, window.devicePixelRatio)
  

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
  
  progressCircle: () ->
    $('.progress-circle').each(() ->
      transcode.progressCircle($(this).attr('id'), $(this).data('progress'))
    )
    
$(document).ready () ->
  $.each(transcode.init, (i, item)->
    item()
  )