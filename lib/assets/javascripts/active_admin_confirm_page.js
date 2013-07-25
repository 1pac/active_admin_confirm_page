$(function(){

function onSubmit(event, xhr, settings) {
  // Create an iframe for the target of the validation request
  $('body').append('<iframe name="uploadiframe" id="uploadiframe"></iframe>');
  $('#uploadiframe').on('load', onLoadIframe);

  // Modify the action to validate and set the target to the iframe.
  var form = $('#main_content form.formtastic');
  form.attr('action', form.attr('action') + '/validate');
  form.attr('target', 'uploadiframe');

  // Clear errors.
  form.find('li.error').removeClass('error');
  form.find('p.inline-errors').remove();

  // Continue the form submission.
  return true;
}

function onLoadIframe() {
  // First, hide the iframe.
  var iframe = $('#uploadiframe');
  iframe.hide();

  var iframe_main_content = iframe.contents().find('#main_content');
  // Ignore the load event when the content is empty.
  if (iframe_main_content.length == 0) return;

  // Reset the target and the action of the form.
  var form = $('#main_content form.formtastic');
  form.removeAttr('target');
  form.attr('action', form.attr('action').replace(/\/validate$/, ''));

  // Enable the disabled submit button.
  $.rails.enableFormElements(form);

  if (iframe_main_content.find('form').length == 0) {
    // Passed validation. Hide inputs and switch handlers of button.
    form.find('.inputs').hide();
    form.find('li.cancel a').one('click', onCancelConfirm);
    form.off('submit', onSubmit);

    // Change the label of the commit button.
    var commit_label = iframe_main_content.find('#commit_button_label').text();
    var commit_button = form.find('input[name="commit"]');
    commit_button.attr('data-orig-value', commit_button.attr('value'));
    commit_button.attr('value', commit_label);

    // Rename the form and insert the confirm page content before it.
    $('#main_content').attr('id', 'orig_main_content');
    $(iframe_main_content).insertBefore('#orig_main_content');
  } else {
    // Copy errors from the form in the iframe to the original form.
    iframe_main_content.find('li.error').each(function(i, li) {
      var dest_li = form.find('#' + li.id);
      dest_li.addClass('error');
      $(li).find('p.inline-errors').each(function(j, p) {
        dest_li.append(p);
      });
    });
  }

  // Now we can remove the iframe.
  iframe.remove();
};

function onCancelConfirm(evt) {
  // Remove the confirm page content and restore the form for validation.
  $('#main_content').remove();
  $('#orig_main_content').attr('id', 'main_content');
  var form = $('#main_content form.formtastic');
  form.on('submit', onSubmit);
  form.find('.inputs').show();

  var commit_button = form.find('input[name="commit"]');
  commit_button.attr('value', commit_button.attr('data-orig-value'));
  return false;
}

$('#main_content form.formtastic').on('submit', onSubmit);

});
