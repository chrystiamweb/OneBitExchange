require 'rest-client'
require 'json'
 
class ExchangeService
  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount.to_f
  end
 
 
  def perform
    begin
      if @source_currency == 'BTC' || @target_currency == 'BTC'
        crypto_currency(@source_currency == 'BTC' ? @target_currency : @source_currency )
      else
        normal_currency
      end

    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def crypto_currency(target)
    url = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=#{target}"
    res = RestClient.get url
    value = JSON.parse(res.body)["#{target}"].to_f
    @source_currency == 'BTC' ? value * @amount : @amount / value 
  end

  def normal_currency
    exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:currency_api_url]
    exchange_api_key = Rails.application.credentials[Rails.env.to_sym][:currency_api_key]
    url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
    res = RestClient.get url
    value = JSON.parse(res.body)['currency'][0]['value'].to_f
    value * @amount
  end
end