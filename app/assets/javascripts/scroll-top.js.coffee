$ ->
  slideToTop = $('<div />')
  slideToTop.html '<i class="fa fa-chevron-up"></i>'
  slideToTop.css
    position: 'fixed'
    bottom: '20px'
    right: '25px'
    width: '40px'
    height: '40px'
    color: '#eee'
    'font-size': ''
    'line-height': '40px'
    'text-align': 'center'
    'background-color': '#222d32'
    cursor: 'pointer'
    'border-radius': '5px'
    'z-index': '99999'
    opacity: '.7'
    'display': 'none'
  slideToTop.on 'mouseenter', ->
    $(this).css 'opacity', '1'
  slideToTop.on 'mouseout', ->
    $(this).css 'opacity', '.7'
  $('.wrapper').append slideToTop
  $(window).scroll ->
    if $(window).scrollTop() >= 150
      if !$(slideToTop).is(':visible')
        $(slideToTop).fadeIn 500
    else
      $(slideToTop).fadeOut 500
  $(slideToTop).click ->
    $('body').animate { scrollTop: 0 }, 500
  $('.sidebar-menu li:not(.treeview) a').click ->
    $this = $(this)
    target = $this.attr('href')
    if typeof target == 'string'
      $('body').animate { scrollTop: $(target).offset().top + 'px' }, 500

  $('.modal').on 'shown.bs.modal', ->
    $(slideToTop).fadeOut 500
