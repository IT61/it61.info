# Ответы сервера:
# 0 - сообщение добавлено в очередь (время отправки от 30 секунд до 2 минут)
# -9 - исчерпан баланс
# -765 - server error(db)
# -761 - invalid datetime
# -767 - invalid phone
# -763 - server errror
module SmsSender
  NoMoneyError = Class.new(RuntimeError)
  ServerDbError = Class.new(RuntimeError)
  InvalidDateTimeError = Class.new(RuntimeError)
  InvalidPhoneError = Class.new(RuntimeError)
  ServerError = Class.new(RuntimeError)
  UnknownResponseCodeError = Class.new(RuntimeError)
  SmsServiceNotConfiguredError = Class.new(RuntimeError)
  NotImplementedError = Class.new(RuntimeError)

  class Epochta
    def initialize
      @epochta = EPochtaService::EPochtaSMS.new(private_key: ENV['EPOCHTA_PRIVATE_KEY'],
                                                public_key: ENV['EPOCHTA_PUBLIC_KEY'])
    end

    def send!(text, sender_name, phone_number, sending_time = nil)
      @phone_number = phone_number
      @sending_time = sending_time
      @sender_name = sender_name
      @type = ENV['EPOCHTA_TYPE'].to_s
      options = { text: text,
                  phone: @phone_number,
                  sms_lifetime: '0',
                  type: @type }

      options[:sender] = @sender_name if @sender_name.present?
      options[:datetime] = @sending_time if @sending_time
      result = @epochta.send_sms(options)
      raise SmsSender::ServerError.new unless result
      result
    end
  end
end