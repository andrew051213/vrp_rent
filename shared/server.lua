tryPayment = function (user_id, price)
    return vRP['tryPayment']{user_id, price, false, 'Car Rent'}
end

tryBankPayment = function (user_id, price)
    return vRP['tryBankPayment']{user_id, price, false, 'Car Rent'}
end