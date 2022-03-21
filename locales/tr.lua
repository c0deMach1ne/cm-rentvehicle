local Translations = {
    info = {
        vehicle_road = "%{plate} plakalı kiralık aracınız vale ile yola çıktı. Lütfen bir yere ayrılmayın."
    },
    error = {
        process = "Araç içindeyken araç kiralayamazsınız.",
        spam = "Zaten bir araç kiraladınız veya kiralayabilecek araç yok. Lütfen daha sonra tekrar deneyin!",
        pay = "Araç kiralayabilmek için yeterli paranız yok."

    },
    success = {
        givekey = "Anahtar teslim edildi.",
        rent_completed = "Araç kiralama işlemi başarıyla gerçekleşti."
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})