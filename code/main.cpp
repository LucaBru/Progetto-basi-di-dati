#include <cstdio>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include "dependencies/include/libpq-fe.h"

#define PG_HOST "localhost"
#define PG_USER "postgres"
#define PG_DB "cesconmatteo"
#define PG_PASS "Prog2.Student"
#define PG_PORT 5432

using std::cin;
using std::cout;
using std::string;
using std::endl;
using std::vector;

void execQuery (PGconn* connection, const char query[]);

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
    char* query[9] = {
        "select Nazione, count(distinct Veicolo) as Veicoli_venduti from Vendita V, Sede S where V.Concessionario = S.ID and Data between '2021-01-01' and '2022-01-01' group by Nazione order by Veicoli_venduti desc",
        "create or replace view IDOR as select Intervento, Dipendente, Ore_Impiegate as Ore, Retribuzione_oraria from Fattura F, Intervento_Dipendente I_D, Impiego_corrente I_C, Contratto C where F.Intervento = I_D.ID and I_D.CF = I_C.Dipendente and I_C.Contratto = C.ID and intervento = '",
        "';select Intervento, sum(Ore*Retribuzione_oraria) from IDOR group by Intervento",
        "select Veicolo, Concessionario, Acquirente from Vendita, Veicolo where Vendita.Veicolo = Veicolo.Telaio and Prezzo = (Select Max(Prezzo) from Vendita, Veicolo where Vendita.Veicolo = Veicolo.telaio)",
        
        
        "create or replace view Optional_aggiuntivi_modello as select Optional, Modello, count(Optional) as Occorrenze from Optional_aggiuntivi O, Veicolo V where O.Veicolo = V.Telaio group by Modello, Optional; select Optional from Optional_aggiuntivi_Modello where modello = '",
        "' and Occorrenze = (select max(Occorrenze) as Numero_installazioni from Optional_aggiuntivi_modello where Modello = '",
        "')",
        
        
        "select Nazione, count(*) as NumeroImpiegati from Sede as S, Impiego_corrente as I where I.Sede = S.ID group by Nazione order by NumeroImpiegati desc",
        "drop view if exists Dip_tot_per_sede; drop view if exists Dipendenti_correnti_per_sede; create view Dipendenti_correnti_per_sede as  select Sede, count(distinct Dipendente) as Num_dip from Impiego_corrente group by Sede; drop view if exists Dipendenti_passati_per_sede; create view Dipendenti_passati_per_sede as select Sede, count(distinct Dipendente) as Num_dip from Impiego_passato group by Sede; create view Dip_tot_per_sede as select Sede, sum(Num_dip) as Numero_dipendenti from (select * from Dipendenti_correnti_per_sede union select * from Dipendenti_passati_per_sede) as Unione_dipendenti group by Sede; select * from Dip_tot_per_sede where Numero_dipendenti = (Select max(Numero_dipendenti)from Dip_tot_per_sede)"
    };
    int option = -1;
    do {
        cout << "Seleziona la query inserendo un numero: \n";
        cout << "1- Numero di veicoli venduti per nazione dal 2021 al 2022\n";
        cout << "2- Calcolo del costo della mano d’opera per l’esecuzione di un determinato intervento a partire dalla fattura\n";
        cout << "3- Acquirente, veicolo, sede della vendita più costosa della società\n";
        cout << "4- Optional aggiuntivo maggiormente desiderato per un determinato modello\n";
        cout << "5- Lista delle nazioni con più dipendenti\n";
        cout << "6- Sede con il maggior numero di dipendenti distinti nell’arco della sua storia\n";
        cout << "0- to exit\nInserire la scelta: ";
        cin >> option;
        cout << endl;
        switch (option) {
            case 1: {
                execQuery (connection, query[0]);
                break;
            }
            case 2: {
                string buffer, par1, tmp1(query[1]), tmp2(query[2]);
                cout << "Inserire il numero di fattura: ";
                cin >> par1;
                buffer = tmp1 + par1 + tmp2;
                execQuery (connection, buffer.c_str());
                break;
            }
            case 3: {
                execQuery (connection, query[3]);
                break;
            }
            case 4: {
                string buffer, par, tmp1(query[4]), tmp2(query[5]), tmp3(query[6]);
                cout << "Inserire il modello: ";
                cin >> par;
                buffer = tmp1 + par + tmp2 + par + tmp3;
                execQuery (connection, buffer.c_str());
                break;
            }
            case 5: {
                execQuery (connection, query[7]);
                break;
            }
            case 6: {
                execQuery (connection, query[8]);
                break;
            }
        }
    } while (option != 0);
    PQfinish(connection);
    return 0;
}

void execQuery (PGconn* connection, const char query[]) {
    PGresult* res;
    res = PQexec (connection, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Result error: " << PQerrorMessage(connection) << endl << endl;
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
