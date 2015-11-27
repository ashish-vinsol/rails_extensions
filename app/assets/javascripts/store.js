
$(document).on("ready, page:change", function() {
  return $('.store .entry > img').click(function() {
    return $(this).parent().find(':submit').click();
  });
});

