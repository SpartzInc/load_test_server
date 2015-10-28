# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  if ($('.load_test_schedules').length > 0)
    #Draw chart and set up bindings to inputs for up to date chart
    draw_load_test_schedule_chart();

    $('body').on 'change', '.load_test_schedules .nested-fields input', (event) ->
      draw_load_test_schedule_chart();

    $('.load_test_schedules').on 'cocoon:after-insert', (event, container) ->
      draw_load_test_schedule_chart();

    $('.load_test_schedules').on 'cocoon:after-remove', (event, container) ->
      draw_load_test_schedule_chart();

    #Add one sub table form by default for stylings and viewing purposes
    if ($('.load_test_schedules .nested-fields').length == 0)
      $('a[data-association-insertion-node=".load_test_schedules"]').trigger('click');

    if ($('.load_test_aws_ec2_instances .nested-fields').length == 0)
      $('a[data-association-insertion-node=".load_test_aws_ec2_instances"]').trigger('click');

    if ($('.load_test_aws_rds_instances .nested-fields').length == 0)
      $('a[data-association-insertion-node=".load_test_aws_rds_instances"]').trigger('click');

#Functions
draw_load_test_schedule_chart = ->
  new Chartkick.LineChart("load_test_schedule_chart", load_test_schedule_data(),
    {
      "discrete": true,
      "library": {
        curveType: 'none',
        hAxis: {
          title: 'Duration (Minutes)'
        },
        vAxis: {
          title: 'Maximum Virtual Users'
        }
      }
    });

load_test_schedule_data = ->
  data_array = [[0, 0]];

  x = 0

  $('.load_test_schedules .nested-fields').each (index, element) =>
    if $(element).is(":visible")
      x += parseInt($(element).find('input:first-child').val());
      y = parseInt($(element).find('input:nth-child(3)').val());
      if !isNaN(x) && !isNaN(y)
        data_array.push([x, y]);

  return data_array;