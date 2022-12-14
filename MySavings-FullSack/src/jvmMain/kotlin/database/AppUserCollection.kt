package database

import models.login.AppUser
import org.bson.BsonDocument
import org.bson.BsonString
import org.litote.kmongo.coroutine.CoroutineClient
import org.litote.kmongo.coroutine.CoroutineCollection
import org.litote.kmongo.coroutine.CoroutineDatabase
import org.litote.kmongo.eq

class AppUserCollection(
    client : CoroutineClient
)  {

    private var database : CoroutineDatabase
    private var collection : CoroutineCollection<AppUser>

    init {
        database = client.getDatabase(AppUser.DB)
        collection = database.getCollection()
    }

    suspend fun insert(appUser: AppUser){
        collection.insertOne(appUser)
    }

    suspend fun remove(id : String) : Boolean {
        val result = collection.deleteOne(AppUser::id eq  id)
       return result.deletedCount > 0
    }

    suspend fun fetch(id: String) : AppUser? {
        val bsonFilter = BsonDocument("id", BsonString(id))
        val user =  collection.find(bsonFilter)
        return user.first()
    }

    suspend fun fetch(password : String, email : String) : AppUser? {
        val emailBson = BsonDocument("email", BsonString(email))
        val passwordBson = BsonDocument("password", BsonString(password))
        val user =  collection.find(emailBson, passwordBson)
        return user.first()
    }

    suspend fun fetchWithPhoneNumber(phoneNumber : String) : AppUser? {
        val phoneNumberBson = BsonDocument("phoneNumber", BsonString(phoneNumber))
        val user =  collection.find(phoneNumberBson)
        return user.first()
    }

}

