$ ->




  # Payment Methods
  new_payment_form = $('#add_payment_method_form')

  process_new_card = (token)->
    $.post("/api/add_user_card", { token: token })
      .done (data)->
        build_flash_message 'Credit Card Saved!', 'success'
        clear_form()
        $("#credit-card-list").append "
          <tr>
            <td>************#{data.number}</td>
            <td>#{data.expire}</td>
          </tr>
        "
      .fail (error)->
        build_flash_message 'We\'re sorry, something went wrong.', 'error'

  build_flash_message = (message, action)->
    alert_html = "<div class=\"alert fade in alert-#{action}\">
      <button class=\"close\" data-dismiss=\"alert\">×</button>
      #{message}
    </div>"
    new_payment_form.find('.alert').remove()
    new_payment_form.prepend alert_html

  new_payment_form.find('.submit').on 'click', (e)->
    e.preventDefault()
    process_form()

  new_payment_form.on 'keypress', (e)->
    process_form() if e.which == 13

  clear_form = ->
    $('#card-number').val('')
    $('#card-cvc').val('')
    $('#card-expiry-month').val('')
    $('#card-expiry-year').val('')

  process_form = ->
    card_details = {
      number: $('#card-number').val(),
      cvc: $('#card-cvc').val(),
      exp_month: $('#card-expiry-month').val(),
      exp_year: $('#card-expiry-year').val()
    }

    Stripe.card.createToken card_details, (response_code, data)->
      if response_code == 200
        process_new_card data.id
        build_flash_message 'Saving your card information...', 'info'
      else
        build_flash_message data.error.message, 'error'
