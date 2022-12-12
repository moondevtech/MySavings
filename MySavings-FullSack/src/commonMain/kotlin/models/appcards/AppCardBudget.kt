package models.appcards

import kotlinx.serialization.Serializable

@Serializable
data class AppCardBudget(
    val id : String,
    val name : String,
    val maxAmount : Double,
    val amountSpent : Double,
    val cardId : String,
    val  transactions: List<AppTransactions>?
) {
}