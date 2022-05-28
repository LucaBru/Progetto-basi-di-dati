#include <cstdio>
#include <iostream>
#include <fstream>
#include <vector>
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
using std::vector;

void execQuery (PGconn* connection, const char query[], int nParam);

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
        cout << "Select a query by the number: \n";
        cout << "1- Numero di veicoli venduti per nazione X in un determinato intervallo di tempo\n";
        cout << "2- Calcolo del costo della mano d’opera per l’esecuzione di un determinato intervento a partire dalla fattura\n";
        cout << "3- Acquirente, veicolo, sede della vendita più costosa della società\n";
        cout << "4- Optional aggiuntivo maggiormente desiderato per un determinato modello\n";
        cout << "5- Lista delle nazioni con più dipendenti\n";
        cout << "6- Sede con il maggior numero di dipendenti distinti nell’arco della sua storia\n";
        cout << "0 to exit\n";
        cin >> option;
        cout << endl;
        switch (option) {
        case 1:
            execQuery (connection, "select Nazione, count(distinct Veicolo) as Veicoli_venduti from Vendita V, Sede S where V.Concessionario = S.ID and Data between $1::date and $2::date group by Nazione order by Veicoli_venduti desc", 2);
            break;
        case 2:
            // CONCATENATO VISTO CHE LE FUNZIONI PQ NON VANNO CON LE VISTE
            execQuery (connection, "INSERIRE QUERY", 0);
            break;
        case 3:
            execQuery (connection, "select Veicolo, Concessionario, Acquirente from Vendita, Veicolo where Vendita.Veicolo = Veicolo.Telaio and Prezzo = (Select Max(Prezzo) from Vendita, Veicolo where Vendita.Veicolo = Veicolo.telaio)", 0);
            break;
        case 4:
            // DA RIGUARDARE
            execQuery (connection, "select Optional from Optional_aggiuntivi group by Optional having count(*) = (select Max(Numero_occorrenze) from (select count(*) as Numero_occorrenze from Optional_aggiuntivi O, Veicolo V where O.veicolo = V.Telaio and V.modello = $1::varchar group by Optional) as Num_occ_per_optional)", 1);
            break;
        case 5:
            execQuery (connection, "select Nazione, count(*) as NumeroImpiegati from Sede as S, Impiego_corrente as I where I.Sede = S.ID group by Nazione order by NumeroImpiegati desc", 0);
            break;
        case 6:
            execQuery (connection, "drop view if exists Dip_tot_per_sede; drop view if exists Dipendenti_correnti_per_sede; create view Dipendenti_correnti_per_sede as  select Sede, count(distinct Dipendente) as Num_dip from Impiego_corrente group by Sede; drop view if exists Dipendenti_passati_per_sede; create view Dipendenti_passati_per_sede as select Sede, count(distinct Dipendente) as Num_dip from Impiego_passato group by Sede; create view Dip_tot_per_sede as select Sede, sum(Num_dip) as Numero_dipendenti from (select * from Dipendenti_correnti_per_sede union select * from Dipendenti_passati_per_sede) as Unione_dipendenti group by Sede; select * from Dip_tot_per_sede where Numero_dipendenti = (Select max(Numero_dipendenti)from Dip_tot_per_sede)", 0);
            break;
        }
    } while (option != 0);
    PQfinish(connection);
    return 0;
}

void execQuery (PGconn* connection, const char query[], int nParam) {
    PGresult* res;
    if (nParam < 1) {
        res = PQexec (connection, query);
    } else {
        PGresult* stmt = PQprepare (connection,"query", query, nParam, NULL);
        char* vals[nParam];
        for (int i=0; i<nParam; i++) {
            string temp;
            cout << "Insert the parameter: ";
            cin >> temp;
            vals[i] = &temp[0];
        }
        res = PQexecPrepared(connection, "query", nParam, vals, NULL, 0, 0);
    }
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Result error: " << PQerrorMessage(connection) << endl << endl;
        if (res != nullptr)
            PQclear(res);
        return;
    }
    PQprintOpt options = {0};
    options.header = 1;
    options.align = 1;
    options.fieldSep = (char*)((" | "));
    PQprint(stdout, res, &options);
    PQclear(res);
}