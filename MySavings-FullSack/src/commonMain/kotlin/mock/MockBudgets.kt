package mock

import models.appcards.AppCardBudget

val mockBudgets : List<AppCardBudget> =  listOf(
    AppCardBudget(
        id = "food".hashCode().toString(),
        name = "Food",
        maxAmount = 1000.0,
        amountSpent = 0.0,
        transactions = null,
        cardId = "card1".hashCode().toString()
    ),

    AppCardBudget(
        id = "bills".hashCode().toString(),
        name = "Bills",
        maxAmount = 2000.0,
        amountSpent = 0.0,
        transactions = null,
        cardId = "card1".hashCode().toString()
    ),

    AppCardBudget(
        id = "extras".hashCode().toString(),
        name = "Extras",
        maxAmount = 2500.0,
        amountSpent = 0.0,
        transactions = null,
        cardId = "card1".hashCode().toString()
    ),
)