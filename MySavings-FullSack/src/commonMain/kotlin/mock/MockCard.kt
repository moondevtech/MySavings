package mock

import io.ktor.util.date.*
import models.appcards.AppCreditCard

val mockCard = AppCreditCard(
    id = "card1".hashCode().toString(),
    accountNumber = "124546772",
    cardHolder = "Jhonny Card",
    cardNumber = "5402278662861637",
    cvv = "123",
    cardType = "MasterCard",
    expirationDate = GMTDate(
        seconds = 0,
        minutes = 0,
        hours = 0,
        dayOfMonth = 0,
        month = Month.JANUARY,
        year = 2028
    ).timestamp,
    budgets = null
)