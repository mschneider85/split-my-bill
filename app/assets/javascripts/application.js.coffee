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
#= require fastclick
#= require autoNumeric
#= require rails.validations
#= require rails.validations.simple_form
#= require highcharts
#= require chartkick
#= require dataTables/jquery.dataTables
#= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
#= require dataTables.select
#= require dataTables.responsive
#= require responsive.bootstrap
#= require jquery.slimscroll
#= require data-confirm-modal
#= require pace
#= require perfect-scrollbar
#= require moment
#= require datetime-moment
#= require_tree .

$(document).ready ->
  $('nav.navbar.navbar-static-top').affix
    offset:
      top: 50

  $.AdminLTE.layout.activate()

  $('.clickable-row').click ->
    window.document.location = $(this).data('href')

  $('.perfectScrollbar').perfectScrollbar(wheelPropagation: true, suppressScrollX: true)

  $('nav.navbar.navbar-static-top').on 'affixed.bs.affix', ->
    $('body>.wrapper, body>.main-header').addClass('affixed')

  $(document).on 'scroll', ->
    if $(document).scrollTop() <= 50
      $('body>.wrapper, body>.main-header').removeClass('affixed')

$(document).on 'page:load', ->
  o = $.AdminLTE.options
  if o.sidebarPushMenu
    $.AdminLTE.pushMenu.activate(o.sidebarToggleSelector)
  $.AdminLTE.layout.activate()

$(document).ajaxStart ->
  Pace.restart()

$ ->
  $('.modal').on 'hidden.bs.modal', ->
    $(this).removeData('bs.modal').find('.modal-content').html('')

  $('.modal').on 'shown.bs.modal', ->
    $('.modal-open').scrollTop(100)
    $(this).find('[autofocus]:first').focus()
    $(this).find('form[data-validate="true"]').enableClientSideValidations();

dataConfirmModal.setDefaults
  title: 'Bist du sicher?'
  commit: 'OK'
  cancel: 'Abbrechen'
