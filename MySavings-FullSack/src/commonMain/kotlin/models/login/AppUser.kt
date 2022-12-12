package models.login

import kotlinx.serialization.Serializable
import models.appcards.AppCreditCard

@Serializable
data class AppUser(
    val id : String,
    val firstname : String,
    val lastname : String,
    val dateOfBirth : Long,
    val registrationDate : Long,
    val password : String,
    val creditCards : List<AppCreditCard>?
) {

    companion object{
        const val PATH = "/user"
    }
}