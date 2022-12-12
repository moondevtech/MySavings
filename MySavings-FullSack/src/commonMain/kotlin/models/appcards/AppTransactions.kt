package models.appcards

import kotlinx.serialization.Serializable

@Serializable
data class AppTransactions(
    val id : String,
    val transactionDate : Long,
    val transactionTitle : String,
    val amount : Double,
    val budgetId : String
) {
}