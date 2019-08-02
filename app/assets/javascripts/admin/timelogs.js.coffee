# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('#datetimepicker').datetimepicker({
  format: 'MMMM D, YYYY h:mm A',
  stepping: 15,
  minDate: Date(),
  maxDate: new Date(Date.now() + (365 * 24 * 60 * 60 * 1000)),
  sideBySide: true,
  icons: {
    up: 'fas fa-arrow-up',
    down: 'fas fa-arrow-down',
    previous: 'fas fa-chevron-left',
    next: 'fas fa-chevron-right',
    close: 'fas fa-times'
  },
  buttons: {showClose: true }
});
