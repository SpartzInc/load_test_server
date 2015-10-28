# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if ($('.aws_rds_instances .nested-fields').length == 0)
    $('a[data-association-insertion-node=".aws_rds_instances"]').trigger('click');

  if ($('.aws_ec2_instances .nested-fields').length == 0)
    $('a[data-association-insertion-node=".aws_ec2_instances"]').trigger('click');