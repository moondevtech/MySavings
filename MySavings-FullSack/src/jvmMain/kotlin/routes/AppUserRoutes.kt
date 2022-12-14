package routes

import database.AppUserCollection
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import mock.mockUser
import models.login.AppUser
import models.response.ApiResponse
import org.litote.kmongo.coroutine.CoroutineClient

class AppUserRoutes(
     client : CoroutineClient
) {

    private val appUserCollection = AppUserCollection(client)

    fun Route.userRoute(){
        get(AppUser.PATH) {
            call.respond(mockUser)
        }

        delete ("${AppUser.PATH}/{id}") {
            val id = call.parameters["id"] ?: error("Invalid delete request")
            val removed =  appUserCollection.remove(id)
            val statusCode : HttpStatusCode = if (removed){
                HttpStatusCode.OK
            }else{
                HttpStatusCode(
                    500,
                    "The user with id $id cannot be removed because it does not exists"
                )
            }
            call.respond(statusCode)

        }
    }

    private fun Route.registerUser(){
        post(AppUser.PATH_REGISTRATION){
            print("RECEIVED ====")
            val user = call.receive<AppUser>()
            print(user.email)
            appUserCollection.insert(user)
            call.respond(ApiResponse(HttpStatusCode.OK.value,"User has been successfully registered"))
        }
    }


    private fun Route.authUserWithEmail(){
        get(AppUser.PATH_LOGIN){
            print(call.request.queryParameters.toString())
            val password =  call.request.queryParameters["password"] ?: ""
            val email =  call.request.queryParameters["email"] ?: ""
            if (password.isEmpty()){
                call.respond(ApiResponse(HttpStatusCode.BadRequest.value, "The password cannot be empty" ) )
                return@get
            }
            if (email.isEmpty()){
                call.respond(ApiResponse(HttpStatusCode.BadRequest.value, "The email cannot be empty" ) )
                return@get
            }


            appUserCollection.fetch(password,email)?.let {
                call.respond(it)
            } ?: run {
                call.respond(ApiResponse(HttpStatusCode.BadRequest.value, "No user known with this credentials"))
            }

        }
    }

    private fun Route.authUserWithPhoneNumber(){
        get(AppUser.PATH_LOGIN_PHONE){
            print(call.request.queryParameters.toString())
            val phoneNumber =  call.request.queryParameters["phoneNumber"] ?: ""
            println("PhoneNumber: $phoneNumber")
            appUserCollection.fetchWithPhoneNumber(phoneNumber)?.let {
                call.respond(it)
            } ?: run {
                if (phoneNumber.isEmpty()){
                    call.respond(ApiResponse(HttpStatusCode.BadRequest.value, "The phone number is invalid" ) )
                }else{
                    call.respond(ApiResponse(HttpStatusCode.BadRequest.value, "No user known with this credentials"))
                }
            }

        }
    }

    fun Application.appUserAuthRouting(){
        routing {
            registerUser()
            authUserWithEmail()
            authUserWithPhoneNumber()
        }
    }
}