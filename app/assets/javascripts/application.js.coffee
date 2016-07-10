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
#= require autoNumeric
#= require rails.validations
#= require rails.validations.simple_form
#= require Chart.bundle
#= require chartkick
#= require dataTables/jquery.dataTables
#= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
#= require jquery.slimscroll
#= require_tree .

$(document).ready ->
  $.AdminLTE.layout.activate()

$(document).on 'page:load', ->
  o = $.AdminLTE.options
  if o.sidebarPushMenu
    $.AdminLTE.pushMenu.activate(o.sidebarToggleSelector)
  $.AdminLTE.layout.activate()

$ ->
  $('.modal').on 'hidden.bs.modal', ->
    $(this).removeData('bs.modal').find('.modal-content').html('')

  $('.modal').on 'shown.bs.modal', ->
    $(this).find('[autofocus]:first').focus()
