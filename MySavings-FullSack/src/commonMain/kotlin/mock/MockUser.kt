package mock

import io.ktor.util.date.*
import models.login.AppUser

var mockUser = AppUser(
    id = "testUser1".hashCode().toString(),
    firstname = "Jhonny",
    lastname = "Card",
    dateOfBirth = GMTDate(
        seconds = 0,
        minutes = 0,
        hours = 0,
        dayOfMonth = 22,
        month = Month.MARCH,
        year = 1994
    ).timestamp,
    registrationDate = GMTDate.START.timestamp,
    password = "123456",
    creditCards = null
)

var mockUserToDelete = AppUser(
    id = "toDelete",
    firstname = "Jhonny",
    lastname = "Card",
    dateOfBirth = GMTDate(
        seconds = 0,
        minutes = 0,
        hours = 0,
        dayOfMonth = 22,
        month = Month.MARCH,
        year = 1994
    ).timestamp,
    registrationDate = GMTDate.START.timestamp,
    password = "123456",
    creditCards = null
)

val mockUsers = mutableListOf(mockUser, mockUserToDelete)