$(document).on 'turbolinks:load', ->
  $('#datetimepicker4').datetimepicker
    format: 'MMMM D, YYYY'
    minDate: Date()
    maxDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000)
    icons:
      up: 'fas fa-arrow-up'
      down: 'fas fa-arrow-down'
      previous: 'fas fa-chevron-left'
      next: 'fas fa-chevron-right'
      close: 'fas fa-times'
    buttons: showClose: true
  $('#datetimepicker3').datetimepicker
    format: 'LT'
    stepping: 15
    icons:
      up: 'fas fa-arrow-up'
      down: 'fas fa-arrow-down'
      close: 'fas fa-times'
    buttons: showClose: true
  return
