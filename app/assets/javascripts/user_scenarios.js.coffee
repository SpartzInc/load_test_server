$(document).ready ->
  order_steps()

  $("#user_scenario_steps").collapse().sortable
    stop: (event, ui)->
      order_steps()

  #init bootstrap collapse for elements with panel-collapse class
  $('.panel-collapse').collapse({toggle: false})
  $('.panel-collapse:first').collapse('toggle')

  #accordian collapse logic
  $('body').on "click", "[data-toggle=collapse-next]", (event) ->
    #Try to close all of the collapse areas first
    parent_id = $(this).data('parent')
    $(parent_id + ' .panel-collapse').collapse('hide')

    $target = $(this).parent().parent().parent().find('.panel-collapse')
    $target.collapse('toggle');

  #Steps
  $('#user_scenario_steps').on 'cocoon:after-insert', (event, step_container) ->
    return if $(step_container).hasClass('request_params')

    $('#user_scenario_steps .panel-collapse').collapse('hide');
    $(step_container).find('.panel-collapse').collapse('toggle');

    order_steps();

  $('#user_scenario_steps').on 'cocoon:after-remove', (event, step_container) ->
    return if $(step_container).hasClass('request_params')

    order_steps();

  #Custom Dropdown
  $('body').on 'click', '.bs-dropdown-to-select-group .dropdown-menu li', (event) ->
    $target = $(event.currentTarget);
    $target.closest('.bs-dropdown-to-select-group')
    .find('[data-bind="bs-drp-sel-value"]').val($target.attr('data-value'))
    .end()
    .children('.dropdown-toggle').dropdown('toggle');
    $target.closest('.bs-dropdown-to-select-group')
    .find('[data-bind="bs-drp-sel-label"]').text($target.attr('data-value'));

    return false;

  if ($('#user_scenario_steps .nested-fields').length == 0)
    $('a[data-association-insertion-node="#user_scenario_steps"]').trigger('click');

### Functions

###

#order_steps function, ste UI and value of each step when called
order_steps = ->
  $('#user_scenario_steps input.step_order').each (index, element) =>
    $(element).val(parseInt(index) + 1)

  $('#user_scenario_steps span.step_number').each (index, element) =>
    $(element).text(parseInt(index) + 1)