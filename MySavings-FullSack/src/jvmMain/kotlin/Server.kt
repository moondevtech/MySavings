import database.AppUserCollection
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.compression.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.routing.*
import org.litote.kmongo.coroutine.coroutine
import org.litote.kmongo.reactivestreams.KMongo
import routes.AppUserRoutes


fun main() {

    val client = KMongo.createClient().coroutine
    val appUserRoutes = AppUserRoutes(client)

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
           with(appUserRoutes){
               userRoute()
           }
        }

        with(appUserRoutes){
            appUserAuthRouting()
        }

    }.start(wait = true)
}