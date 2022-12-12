package mock

import io.ktor.util.date.*
import models.appcards.AppTransactions

val mockTransactions =  listOf(

    //FOOD BUDGET
    AppTransactions(
        id= "test1".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 28, month= Month.APRIL, year = 2022).timestamp,
        transactionTitle = "Bread",
        amount = 7.0,
        budgetId = "budget1".hashCode().toString()
    ),

    AppTransactions(
        id= "test2".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 29, month= Month.APRIL, year = 2022).timestamp,
        transactionTitle = "Ketchup",
        amount = 12.0,
        budgetId = "budget1".hashCode().toString()
    ),
    // BILLS BUDGET
    AppTransactions(
        id= "test3".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 1, month= Month.MARCH, year = 2022).timestamp,
        transactionTitle = "Electricity",
        amount = 120.0,
        budgetId = "budget2".hashCode().toString()
    ),

    AppTransactions(
        id= "test4".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 1, month= Month.MARCH, year = 2022).timestamp,
        transactionTitle = "Water",
        amount = 80.70,
        budgetId = "budget2".hashCode().toString()
    ),
    // EXTRAS BUDGET

    AppTransactions(
        id= "test4".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 1, month= Month.JUNE, year = 2022).timestamp,
        transactionTitle = "Drinks",
        amount = 40.45,
        budgetId = "budget3".hashCode().toString()
    ),

    AppTransactions(
        id= "test4".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 7, month= Month.JULY, year = 2022).timestamp,
        transactionTitle = "Pizza",
        amount = 80.70,
        budgetId = "budget3".hashCode().toString()
    ),
    // BILLS BUDGET
    AppTransactions(
        id= "test5".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 2, month= Month.JUNE, year = 2022).timestamp,
        transactionTitle = "IceCream",
        amount = 120.0,
        budgetId = "budget3".hashCode().toString()
    ),

    AppTransactions(
        id= "test6".hashCode().toString(),
        transactionDate = GMTDate(seconds =  0, minutes = 0, hours = 0,dayOfMonth = 1, month= Month.MARCH, year = 2022).timestamp,
        transactionTitle = "Cinema",
        amount = 80.70,
        budgetId = "budget3".hashCode().toString()
    ),
)