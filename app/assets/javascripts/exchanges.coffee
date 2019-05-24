$(document).ready ->

  $('.form-control').change ->
    changeData()

  $('#invert-currency').click ->
    aux = $("#target_currency").val()
    $("#target_currency").val($("#source_currency").val())
    $("#source_currency").val(aux)
    changeData()  
  
  changeData = ->
   
    if $('#amount').val()
          $.ajax '/convert',
              type: 'GET'
              dataType: 'json'
              data: {
                      source_currency: $("#source_currency").val(),
                      target_currency: $("#target_currency").val(),
                      amount: $("#amount").val()
                    }
              error: (jqXHR, textStatus, errorThrown) ->
                alert textStatus
              success: (data, text, jqXHR) ->
                $('#result').val(data.value)
            return false;
    
    
  
  
  