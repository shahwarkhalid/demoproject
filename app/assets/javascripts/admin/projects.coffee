@bind_chosen_select = ->
 $('.chosen-select').chosen
   allow_single_deselect: true
   no_results_text: 'No results matched'
   width: '200px'

$(document).on 'turbolinks:load', ->
 bind_chosen_select()
