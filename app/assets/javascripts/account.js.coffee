$ ->

  # Page Helpers

  build_page_flash_method = (message, action)->
    alert_html = "<div class=\"alert fade in alert-#{action}\">
      <button class=\"close\" data-dismiss=\"alert\">×</button>
      #{message}
    </div>"
    $('.content.container').prepend alert_html

  # ========== Payment History ==========
  if window.location.pathname == '/account/payment_history'

    # Variables
    payment_history_table = $('#payment-history-list')

    # Helpers
    payment_status = (paid)->
      if paid
        "Successful Payment"
      else
        "Failed Payment"

    format_payment_history_row = (payment)->
      "<tr>
         <td>#{payment_status(payment.paid)}</td>
         <td>$#{parseFloat(payment.amount * 0.01).toFixed(2)}</td>
         <td>************#{payment.card.last4}</td>
         <td>#{new Date(payment.created * 1000)}</td>
       </tr>"

    # Functions
    load_payment_history = ->
      $.get("/account/payment_history.json")
        .done (response)->
          table_html = ''
          $.each response.data, (i, payment)->
            table_html += format_payment_history_row payment
          payment_history_table.find('.loading-payment-history').remove()
          payment_history_table.append table_html
          window.update_page_height()
        .fail (error)->
          build_page_flash_method 'We\'re sorry, something went wrong while loading your Payment History.', 'error'


    # Listeners


    # Initialize
    load_payment_history()


  # ========== Payment Methods ==========
  if window.location.pathname == '/account/payment_methods'

    # Variables
    new_payment_form = $('#add-payment-method-form')
    payment_method_table = $('#payment-method-list')

    # Helpers
    format_payment_method_row = (payment_method)->
      "<tr>
         <td>************#{payment_method.last4}</td>
         <td>#{payment_method.type}</td>
         <td>#{payment_method.exp_month}/#{payment_method.exp_year}</td>
       </tr>"

    build_form_flash_method = (message, action)->
      alert_html = "<div class=\"alert fade in alert-#{action}\">
        <button class=\"close\" data-dismiss=\"alert\">×</button>
        #{message}
      </div>"
      new_payment_form.find('.alert').remove()
      new_payment_form.prepend alert_html

    # Functions
    process_new_card = (token)->
      $.post("/api/add_user_card", { token: token })
        .done (data)->
          build_form_flash_method 'Credit Card Saved!', 'success'
          clear_form()
          payment_method_table.append format_payment_method_row data
        .fail (error)->
          build_form_flash_method 'We\'re sorry, something went wrong.', 'error'

    clear_form = ->
      $('#card-number').val('')
      $('#card-cvc').val('')
      $('#card-expiry-month').val('')
      $('#card-expiry-year').val('')

    load_payment_methods = ->
      $.get("/account/payment_methods.json")
        .done (response)->
          table_html = ''
          $.each response.data, (i, payment_method)->
            table_html += format_payment_method_row payment_method
          payment_method_table.find('.loading-payment-methods').remove()
          payment_method_table.append table_html
          window.update_page_height()
        .fail (error)->
          build_page_flash_method 'We\'re sorry, something went wrong while loading your Payment Methods.', 'error'


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
          build_form_flash_method 'Saving your card information...', 'info'
        else
          build_form_flash_method data.error.message, 'error'

    # Listeners

    new_payment_form.find('.submit').on 'click', (e)->
      e.preventDefault()
      process_form()

    new_payment_form.on 'keypress', (e)->
      process_form() if e.which == 13

    # Initialize
    load_payment_methods()


