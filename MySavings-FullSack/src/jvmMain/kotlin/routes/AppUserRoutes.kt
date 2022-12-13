package routes

import database.AppUserCollection
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import mock.mockUser
import mock.mockUsers
import models.login.AppUser
import org.litote.kmongo.coroutine.CoroutineClient

class AppUserRoutes(
     client : CoroutineClient
) {

    private val appUserCollection = AppUserCollection(client)

    fun Route.userRoute(){
        get(AppUser.PATH) {
            call.respond(mockUser)
        }

        createUser()

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

    private fun Route.createUser(){
        post(AppUser.PATH_REGISTRATION){
            val user = call.receive<AppUser>()
            appUserCollection.insert(user)
            call.respond(HttpStatusCode.OK)
        }
    }


    private fun Route.authUser(){
        get(AppUser.PATH_LOGIN){
            print(call.request.queryParameters.toString())
            val password =  call.request.queryParameters["password"] ?: ""
            val email =  call.request.queryParameters["email"] ?: ""
            if (password.isEmpty()){
                call.respond(HttpStatusCode(HttpStatusCode.BadRequest.value, "The password cannot be empty" ) )
                return@get
            }
            if (email.isEmpty()){
                call.respond(HttpStatusCode(HttpStatusCode.BadRequest.value, "The email cannot be empty" ) )
                return@get
            }


            appUserCollection.fetch(password,email)?.let {
                call.respond(it)
            } ?: run {
                call.respond(HttpStatusCode.BadRequest, "No user known with this credentials")
            }

        }
    }

    fun Application.appUserAuthRouting(){
        routing {
            createUser()
            authUser()
        }
    }
}