function transmitter(send_rate, receive_frequency, text)
send_rate = double(send_rate)
receive_frequency = double(receive_frequency)
sendData(send_rate, receive_frequency, send_text(text))