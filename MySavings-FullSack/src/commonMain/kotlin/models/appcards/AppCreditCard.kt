package models.appcards

import kotlinx.serialization.Serializable

@Serializable
data class AppCreditCard(
    val id : String,
    val accountNumber: String,
    val cardHolder : String,
    val cardNumber : String,
    val cvv : String,
    val cardType : String,
    var bankName : String,
    val expirationDate : Long,
    val budgets : List<AppCardBudget>?
) {
}