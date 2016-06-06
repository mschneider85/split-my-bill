# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require turbolinks
#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require bootstrap-sprockets
#= require admin-lte
#= require rails.validations
#= require rails.validations.simple_form
#= require Chart.bundle
#= require chartkick
#= require_tree .

$(document).ready ->
  $.AdminLTE.layout.activate()

$(document).on 'page:load', ->
  o = $.AdminLTE.options
  if o.sidebarPushMenu
    $.AdminLTE.pushMenu.activate(o.sidebarToggleSelector)
  $.AdminLTE.layout.activate()

$(document).on 'page:fetch', -> fadeout()
$(document).on 'page:change', -> fadein()
$(document).on 'page:before-unload', -> remove()
$(document).on 'page:restore', -> remove()

fadeout = ->
  $('section.content').addClass('animated fadeOut')
  setTimeout( ->
      $('#ajax-loader').fadeIn('slow')
    , 1500
  )

fadein = ->
  $('section.content').addClass('animated fadeIn')
  setTimeout( remove(), 1000 )

remove = ->
  $('section.content').removeClass('animated fadeOut fadeIn')
  $('#ajax-loader').hide()
