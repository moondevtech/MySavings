package models.login

import kotlinx.serialization.Serializable
import models.DatabaseModelType
import models.appcards.AppCreditCard

@Serializable
data class AppUser(
    override val id : String,
    val email : String,
    val phoneNumber : String,
    val firstname : String,
    val lastname : String,
    val dateOfBirth : Long,
    val registrationDate : Long,
    val password : String,
    val creditCards : List<AppCreditCard>?
) : DatabaseModelType  {

    override val db: String
        get() = DB

    companion object{
        const val PATH = "/user"
        const val PATH_LOGIN = "/login/user"
        const val PATH_LOGIN_PHONE = "/login_phone/user"
        const val PATH_REGISTRATION = "/register/user"
        const val DB = "MY_SAVINGS_DB"
    }

}