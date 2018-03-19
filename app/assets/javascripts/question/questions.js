$(function() {

  $(document).on('turbolinks:load', function() {
    check_to_hide_or_show_add_link();
    numbering_placeholder();
    $('#answer-association-insertion-point').on('cocoon:after-insert', function() {
      check_to_hide_or_show_add_link();
      numbering_placeholder();
    });
    $('#answer-association-insertion-point').on('cocoon:after-remove', function() {
      check_to_hide_or_show_add_link();
      numbering_placeholder();
    });
    //$('input#answer-field').on('keydown keyup keypress change', function() {
    check_input();
    $(document).on('keydown keyup keypress change', 'input#answer-field, input#question_content', function() {
      check_input();
    });
  });


  function check_to_hide_or_show_add_link() {
    if ( $('input#answer-field').length && $('input#answer-field').length >= 4) {
      $('#add-answer').hide();
    } else {
      $('#add-answer').show();
    }
  }

  function numbering_placeholder() {
    $('input#answer-field').each(function(index, value) {
      let s = "回答" + (index+1);
      if (index+1 > 2) {
        s += " (オプション)";
      }
      $(this).attr('placeholder', s);
    });
  }

  function check_input() {
    let q_flag = false;

    if ( $('div div input#question_content').length && $('div div input#question_content').val().length) {
      q_flag = true;
    }
    let ans_cnt = 0;
    $('div input#answer-field').each(function() {
      if ( $(this).val().length > 0) {
        ans_cnt += 1;
      }
    });
    if ( q_flag && ans_cnt >= 2) {
      $('#submit').prop('disabled',false);
    } else {
      $('#submit').prop('disabled',true);
    }
  }
})
