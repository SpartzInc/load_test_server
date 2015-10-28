# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.datetimepicker').datetimepicker()

  $('#test_result_aws_ec2_instances').on 'cocoon:after-insert', (event, step_container) ->
    $('.datetimepicker').datetimepicker()

  $('#test_result_aws_rds_instances').on 'cocoon:after-insert', (event, step_container) ->
    $('.datetimepicker').datetimepicker()

  $('#load_test_filter').on 'change', (event) ->
    window.location.href =
      window.location.protocol + '//' + window.location.host + window.location.pathname + '?filter=' + $("#load_test_filter option:selected").val();