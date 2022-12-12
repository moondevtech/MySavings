import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.compression.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import mock.mockUser
import mock.mockUsers
import models.login.AppUser

fun main() {
    println("Hello, JVM!")
    embeddedServer(Netty, 9090) {
        install(ContentNegotiation){
            json()
        }
        install(CORS){
            allowMethod(HttpMethod.Get)
            allowMethod(HttpMethod.Post)
            allowMethod(HttpMethod.Delete)
            anyHost()
        }
        install(Compression){
            gzip()
        }
        routing {
            route(AppUser.PATH){
                get {
                    call.respond(mockUser)
                }

                post {
                    mockUsers += call.receive<AppUser>()
                    call.respond(HttpStatusCode.OK)
                }

                delete ("/{id}") {
                    val id = call.parameters["id"] ?: error("Invalid delete request")
                    mockUsers.firstOrNull { it.id == id }
                        ?.let {
                            mockUsers.removeAll { it.id == id }
                            call.respond(HttpStatusCode.OK)
                        } ?: run {
                        call.respond(HttpStatusCode(500, "The user with id $id cannot be removed because it does not exists"))
                    }
                }
            }
        }
    }.start(wait = true)
}