#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

#define PG_HOST "localhost" //oppure "localhost" o "postgresql"
#define PG_USER "postgres" //il vostro nome utente
#define PG_DB "cesconmatteo" //il nome del database
#define PG_PASS "Prog2.Student" //la vostra password
#define PG_PORT 5432

using std::cin;
using std::cout;
using std::string;
using std::endl;

void printQuery (PGconn* connection, const char query[]);

int main () {
    char connInfo[250];
    sprintf(connInfo, "user=%s password=%s dbname=%s host=%s port=%d", PG_USER,PG_PASS , PG_DB , PG_HOST , PG_PORT);
    PGconn* connection;
    connection = PQconnectdb (connInfo);
    if (PQstatus(connection) != CONNECTION_OK){
        cout<<"Connection error"<<PQerrorMessage(connection);
        PQfinish(connection);
        exit(1);
    }
    
    int option = -1;
    do {
        cout << "Select a query by the number: \n" << "1- Query 1\n" << "2- Query 2\n" << "3- Query 3\n" << "4- Query 4\n" << "5- Query 5\n" << "0 to exit\n";
        cin >> option;
        cout << endl;
        switch (option) {
        case 1:
            printQuery (connection, "SELECT * FROM azienda");
            break;
        case 2:
            printQuery (connection, "SELECT * FROM veicolo");
            break;
        case 3:
            printQuery (connection, "SELECT * FROM ciao");
            break;
        case 4:
            printQuery (connection, "SELECT * FROM modello");
            break;
        case 5:
            printQuery (connection, "SELECT * FROM Impiego_corrente");
            break;
        }
    } while (option != 0);
    PQfinish(connection);
    return 0;
}

void printQuery (PGconn* connection, const char query[]) {
    PGresult* res;
    res = PQexec (connection, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Result error" << PQerrorMessage(connection) << endl << endl;
        PQclear(res);
        return;
    }
    int tuple = PQntuples(res);
    int campi = PQnfields(res);
    for(int i=0; i < campi; ++i){
        cout << PQfname(res,i) << "\t\t";
    }
    cout << endl;
    for(int i=0; i < tuple;++i){
        for (int j = 0; j < campi; ++j) {
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
}