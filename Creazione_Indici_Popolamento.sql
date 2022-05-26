CREATE TABLE Acquirente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);

CREATE INDEX idx_Acquirente ON Acquirente USING hash (CF);

CREATE TABLE Persona (
	CF VARCHAR(16) PRIMARY KEY,
	Cognome VARCHAR(50) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente (CF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Azienda (
    CF VARCHAR(16) PRIMARY KEY, 
	PIVA VARCHAR(17) NOT NULL,
	FOREIGN KEY (CF) REFERENCES Acquirente(CF)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TYPE MANSIONE AS ENUM ('Impiegato', 'Meccanico', 'Dirigente');
CREATE TABLE Dipendente (
	CF VARCHAR(16) PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	Mansione MANSIONE NOT NULL,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	Civico VARCHAR(8) NOT NULL
);

CREATE TYPE TIPO_SEDE AS ENUM ('Officina', 'Concessionario');
CREATE TABLE Sede (
	ID VARCHAR PRIMARY KEY,
	Tipo TIPO_SEDE,
	Nazione VARCHAR(50) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	Via VARCHAR(50) NOT NULL,
    Civico VARCHAR(8) NOT NULL,
    UNIQUE (Tipo, Città, Via, Civico)	
);

CREATE TYPE TIPO_CONTRATTO AS ENUM ('Stagista', 'Apprendista', 'Determinato', 'Indeterminato');
CREATE TABLE Contratto (
	ID VARCHAR PRIMARY KEY,
    Tipo TIPO_CONTRATTO,
    Retribuzione_oraria DOUBLE PRECISION NOT NULL,
    Livello INT NOT NULL
);

CREATE TABLE Impiego_corrente (
	Dipendente VARCHAR (16) PRIMARY KEY,
	Contratto VARCHAR NOT NULL,
	Sede VARCHAR NOT NULL,
	Inizio DATE NOT NULL,
	FOREIGN KEY (Dipendente) REFERENCES Dipendente(CF) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Sede) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Impiego_Passato (
	Dipendente VARCHAR(16),
	Inizio DATE,
	Fine DATE NOT NULL,
	Contratto VARCHAR NOT NULL,
	Sede VARCHAR NOT NULL,
	PRIMARY KEY(Dipendente, Inizio),
	FOREIGN KEY (Contratto) REFERENCES Contratto(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Sede) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Modello (
	Nome VARCHAR(50) PRIMARY KEY,
	Costruttore VARCHAR(20) NOT NULL,
	Inizio_Produzione INT4 CHECK (Inizio_Produzione > 1959 AND Inizio_Produzione <= EXTRACT (YEAR FROM CURRENT_DATE))
);

CREATE TABLE Veicolo  (
	Telaio VARCHAR(17) PRIMARY KEY,
	Prezzo DOUBLE PRECISION NOT NULL,
	Anno DATE NOT NULL,
    Modello VARCHAR(30) NOT NULL,
    FOREIGN KEY (Modello) REFERENCES Modello(Nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_VTelaio ON Veicolo USING hash (Telaio);
CREATE INDEX idx_VPrezzo ON Veicolo (Prezzo);

CREATE TABLE Veicolo_immatricolato (
	Telaio VARCHAR(17) PRIMARY KEY,
	Targa VARCHAR(10) NOT NULL,
	KM INT DEFAULT 0 NOT NULL,
	FOREIGN KEY (Telaio) REFERENCES Veicolo (Telaio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Optional (
	Codice VARCHAR(15) PRIMARY KEY,
	Categoria VARCHAR(50) NOT NULL,
	Fornitore VARCHAR(50) NOT NULL
);

CREATE TABLE Optional_base (
	Modello VARCHAR(30),
	Optional VARCHAR(15),
	PRIMARY KEY(Modello, Optional),
	FOREIGN KEY (Modello) REFERENCES Modello(Nome) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Optional) REFERENCES Optional(Codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Optional_Aggiuntivi (
	Veicolo VARCHAR (17),
	Optional VARCHAR (15),
	Prezzo DOUBLE PRECISION NOT NULL,
	PRIMARY KEY (Veicolo, Optional),
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Optional) REFERENCES Optional(Codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Intervento (
	ID VARCHAR PRIMARY KEY,
	Veicolo VARCHAR (17) NOT NULL,
	Officina VARCHAR NOT NULL,
	FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Officina) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Fattura (
	Numero VARCHAR PRIMARY KEY,
	Intervento VARCHAR NOT NULL,
	Netto FLOAT NOT NULL,
	Iva INT NOT NULL,
	Data DATE NOT NULL,
	FOREIGN KEY (Intervento) REFERENCES Intervento (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Intervento_Dipendente (
    ID VARCHAR,
    CF VARCHAR(16),
    Ore_Impiegate DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID, CF),
    FOREIGN KEY (ID) REFERENCES Intervento (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CF) REFERENCES DIPENDENTE (CF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Vendita (
	Veicolo VARCHAR (17),
	Concessionario VARCHAR,
	Acquirente VARCHAR (16),
	Data DATE,
	PRIMARY KEY (Veicolo, Concessionario, Acquirente, Data),
    FOREIGN KEY (Veicolo) REFERENCES Veicolo(Telaio) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Acquirente) REFERENCES Acquirente(CF) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Concessionario) REFERENCES Sede(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('CJWXVI75K97O770Z', 'Terencio', 'United States', 'Salt Lake City', 'Comanche', '7700');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('AVGOIN39B71A372L', 'Essie', 'Indonesia', 'Dasanlian Lauk', 'Caliangt', '71445');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('MLFHXV46E30O654L', 'Gilberto', 'Ukraine', 'Rokytne', 'Drewry', '21078');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('MRFVNW64L86M192G', 'Vinita', 'Peru', 'Huanchaco', 'Union', '2');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ELTAIO04A49G866C', 'Luciana', 'Portugal', 'Portelinha', 'Cottonwood', '943');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('INDCTE42Y17P762V', 'Shanie', 'Tajikistan', 'Obigarm', 'Chinook', '54');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('DAKRMQ02Q92T379V', 'Rab', 'Colombia', 'Ariguaní', 'Express', '03');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('AVCOUE99U68N227I', 'Katalin', 'China', 'Dashi', 'Jenna', '723');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('DPLNGW14F22B788P', 'Daphene', 'Uruguay', 'Durazno', 'Merry', '22181');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('OUBDSQ40E91N474L', 'Drona', 'United States', 'Columbus', 'Jay', '18342');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('JULGBD78U32G348M', 'Maryellen', 'China', 'Xiaozhi', 'Maple Wood', '41');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('RZEBKN50I75E721Z', 'Briano', 'France', 'Paris 11', 'Hanson', '8');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('NARVQT95X88Z566S', 'Purcell', 'China', 'Nankou', 'Colorado', '71067');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('YBORFQ16W63N987T', 'Tobiah', 'Canada', 'Salaberry-de-Valleyfield', 'Di Loreto', '769');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('YSFHNX42Y05R850D', 'Meredith', 'Vietnam', 'Quán Hàu', 'Jenna', '33');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('FYAKJL54I85Q628W', 'Alexandra', 'Indonesia', 'Subulussalam', '1st', '62980');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('PQGELO38P79B350H', 'Cord', 'Afghanistan', 'Qarchī Gak', 'Barnett', '58605');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('KMTZSP21S19M498M', 'Amandie', 'Sweden', 'Nybro', 'Pawling', '31');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('WYLIPR44J46D615Q', 'Jordon', 'Liberia', 'Buchanan', 'Crownhardt', '0');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('NJTPUB51V14R776B', 'Farra', 'Sweden', 'Skene', 'Farwell', '542');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('NDLUCQ13W52W823O', 'Tuesday', 'Canada', 'Inuvik', 'International', '38214');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('AXOHJG07F50J933M', 'Torie', 'Turkmenistan', 'Tejen', 'Scott', '7795');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('VYMPFN25U94Y729E', 'Olin', 'Latvia', 'Iecava', 'Packers', '6191');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('RAILYN20V92Q723A', 'Andeee', 'China', 'Laxiong', 'Veith', '42');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('TCRFZS73L27N235Z', 'Christophe', 'Brazil', 'Pontes e Lacerda', 'Jenna', '88184');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('MHAQFI37H28U661I', 'Farlie', 'Jordan', 'Al Kittah', 'Sloan', '6705');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('JRBVIQ23P17A981T', 'Pammy', 'Brazil', 'Andradina', 'Hoard', '482');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('OZUGJV98G14U458V', 'Lazaro', 'Czech Republic', 'Kozmice', 'Daystar', '60103');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ISDBTV10D86U364I', 'Bianka', 'Russia', 'Blagodatnoye', 'Melvin', '821');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('RJHLQA33O49V146H', 'North', 'China', 'Shangshuai', 'Service', '57');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ZOLEIK97I41Z558Y', 'Lavinia', 'Turkmenistan', 'Türkmenbaşy', 'Bluejay', '4');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ADROVL45T44M509D', 'Llewellyn', 'Gabon', 'Fougamou', 'Chinook', '9');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('MTPDKW50E99C357T', 'Euphemia', 'Poland', 'Skarbimierz Osiedle', 'Michigan', '6893');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('EJWAIH01E10K907P', 'Hedvig', 'China', 'Daqiao', 'Bluestem', '431');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('XLHORE99Q56K969T', 'Ede', 'Russia', 'Vidyayevo', 'Nova', '531');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('HKTIWD87M28H697V', 'Chiquita', 'Panama', 'Los Algarrobos', 'Golf Course', '233');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ASEONX67S98M916E', 'Mortimer', 'Japan', 'Hiji', '4th', '0753');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ZKAHSL01P63L002M', 'Trixie', 'Japan', 'Sasaguri', 'Mitchell', '498');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('EWKQGZ17F74X222N', 'Neda', 'Thailand', 'Lat Lum Kaeo', 'Sauthoff', '997');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('HNRZJV87O80G262T', 'Sinclare', 'Thailand', 'Bang Nam Priao', 'Maple Wood', '530');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('OJCXYS67J46I803L', 'Cecil', 'Philippines', 'Jagna', 'Logan', '54080');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('PJDYWL58U69J587W', 'Emmerich', 'Philippines', 'Madalum', 'Hauk', '11025');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('JLVAPQ38T41A891P', 'Ferdinande', 'Philippines', 'Bulawin', 'Warner', '16334');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('DGNEVR17W09Y796O', 'Aurelie', 'Syria', 'Al Manşūrah', 'Crescent Oaks', '62');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('STHYZC13X52S041C', 'Zsazsa', 'France', 'Aix-en-Provence', 'Fulton', '53');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('ZWPAGM10M08D347T', 'Amerigo', 'Qatar', 'Umm Şalāl ‘Alī', 'Porter', '3');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('NVEKYX27O37F254S', 'Frankie', 'United States', 'Erie', 'Golf View', '20567');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('WXPBUA62P61G788N', 'Klemens', 'New Zealand', 'Taipa', 'Anniversary', '46794');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('DSYCFB64D98Y457D', 'Caren', 'China', 'Wudangshan', 'Troy', '20782');
insert into Acquirente (CF, Nome, Nazione, Città, Via, Civico) values ('EDPANR00I12A043H', 'Adelaida', 'China', 'Jingping', 'Parkside', '67896');
insert into Azienda (CF, PIVA) values ('ZOLEIK97I41Z558Y', '68371723409548925');
insert into Azienda (CF, PIVA) values ('NVEKYX27O37F254S', '35463490080112629');
insert into Azienda (CF, PIVA) values ('OJCXYS67J46I803L', '65946527854723746');
insert into Azienda (CF, PIVA) values ('ADROVL45T44M509D', '63589697549983079');
insert into Azienda (CF, PIVA) values ('MHAQFI37H28U661I', '57639809215690114');
insert into Azienda (CF, PIVA) values ('XLHORE99Q56K969T', '60101131677019923');
insert into Azienda (CF, PIVA) values ('ISDBTV10D86U364I', '34166494587350795');
insert into Azienda (CF, PIVA) values ('RJHLQA33O49V146H', '04817248119971853');
insert into Azienda (CF, PIVA) values ('JLVAPQ38T41A891P', '62836969019002829');
insert into Azienda (CF, PIVA) values ('PJDYWL58U69J587W', '78780251388585924');
insert into Azienda (CF, PIVA) values ('EWKQGZ17F74X222N', '52706561389196011');
insert into Azienda (CF, PIVA) values ('WXPBUA62P61G788N', '58165606204612620');
insert into Azienda (CF, PIVA) values ('HNRZJV87O80G262T', '97504208536747291');
insert into Azienda (CF, PIVA) values ('ZKAHSL01P63L002M', '87691075961145788');
insert into Azienda (CF, PIVA) values ('DGNEVR17W09Y796O', '33594075872831630');
insert into Azienda (CF, PIVA) values ('OZUGJV98G14U458V', '58301576667521382');
insert into Azienda (CF, PIVA) values ('DSYCFB64D98Y457D', '60355988339702901');
insert into Azienda (CF, PIVA) values ('EJWAIH01E10K907P', '77498465900747483');
insert into Azienda (CF, PIVA) values ('ZWPAGM10M08D347T', '05568303508567153');
insert into Azienda (CF, PIVA) values ('JRBVIQ23P17A981T', '76794308808934851');
insert into Azienda (CF, PIVA) values ('STHYZC13X52S041C', '38325732784307301');
insert into Azienda (CF, PIVA) values ('MTPDKW50E99C357T', '77832927707657063');
insert into Azienda (CF, PIVA) values ('EDPANR00I12A043H', '87402867608413110');
insert into Azienda (CF, PIVA) values ('HKTIWD87M28H697V', '04349442803321382');
insert into Azienda (CF, PIVA) values ('ASEONX67S98M916E', '58803856413044056');
insert into Persona (CF, Cognome) values ('PQGELO38P79B350H', 'Ledingham');
insert into Persona (CF, Cognome) values ('RAILYN20V92Q723A', 'Skeermer');
insert into Persona (CF, Cognome) values ('OUBDSQ40E91N474L', 'Matushenko');
insert into Persona (CF, Cognome) values ('VYMPFN25U94Y729E', 'Stackbridge');
insert into Persona (CF, Cognome) values ('AVCOUE99U68N227I', 'Gallienne');
insert into Persona (CF, Cognome) values ('YSFHNX42Y05R850D', 'Ortiga');
insert into Persona (CF, Cognome) values ('WYLIPR44J46D615Q', 'Getch');
insert into Persona (CF, Cognome) values ('NDLUCQ13W52W823O', 'Tollady');
insert into Persona (CF, Cognome) values ('RZEBKN50I75E721Z', 'Danielli');
insert into Persona (CF, Cognome) values ('NJTPUB51V14R776B', 'Dericot');
insert into Persona (CF, Cognome) values ('AVGOIN39B71A372L', 'Retchford');
insert into Persona (CF, Cognome) values ('TCRFZS73L27N235Z', 'Ranscombe');
insert into Persona (CF, Cognome) values ('NARVQT95X88Z566S', 'Copeman');
insert into Persona (CF, Cognome) values ('DPLNGW14F22B788P', 'Hammerstone');
insert into Persona (CF, Cognome) values ('FYAKJL54I85Q628W', 'Ales');
insert into Persona (CF, Cognome) values ('INDCTE42Y17P762V', 'Gemelli');
insert into Persona (CF, Cognome) values ('CJWXVI75K97O770Z', 'Cescon');
insert into Persona (CF, Cognome) values ('MLFHXV46E30O654L', 'Soligon');
insert into Persona (CF, Cognome) values ('MRFVNW64L86M192G', 'Francescon');
insert into Persona (CF, Cognome) values ('ELTAIO04A49G866C', 'Fantuzzi');
insert into Persona (CF, Cognome) values ('JULGBD78U32G348M', 'Smith');
insert into Persona (CF, Cognome) values ('YBORFQ16W63N987T', 'Hill');
insert into Persona (CF, Cognome) values ('KMTZSP21S19M498M', 'Power');
insert into Persona (CF, Cognome) values ('AXOHJG07F50J933M', 'Scott');
insert into Persona (CF, Cognome) values ('DAKRMQ02Q92T379V', 'Richards');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('RYFWZO66L14L336W', 'Farica', 'Meynell', 'Meccanico', 'Ukraine', 'Terny', '5th', '803');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('IKGRTQ94H83A629Q', 'D''arcy', 'Spurier', 'Impiegato', 'Indonesia', 'Pondokaso', 'Schiller', '0117');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('TIPWMQ35E19R424U', 'Grady', 'Skase', 'Dirigente', 'Vietnam', 'Quỳ Châu', 'Lukken', '73344');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('GEQMOH78M92C221Q', 'Felicity', 'Belz', 'Dirigente', 'Poland', 'Józefów', 'Truax', '33');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('RTIBLG42H44E431C', 'Saxe', 'Mengue', 'Impiegato', 'France', 'Boulogne-sur-Mer', 'Lukken', '2');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('VOBNUF63N53R914Y', 'Dieter', 'O''Kynsillaghe', 'Meccanico', 'Serbia', 'Seleuš', 'Springs', '6047');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('KYWTIC72Y14C857P', 'Brigit', 'Matusevich', 'Impiegato', 'Ukraine', 'Banyliv', 'Main', '3');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('ZSCQHT02T02K420Z', 'Manda', 'Skully', 'Impiegato', 'China', 'Hongtu', '3rd', '20114');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('NUYBQZ04M81Z337X', 'Winnie', 'Goring', 'Dirigente', 'Finland', 'Rautjärvi', 'Charing Cross', '7');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('UXAWKM77U99Q663Y', 'Valentine', 'Shillaker', 'Dirigente', 'Philippines', 'Sabang', 'Mcbride', '85');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('QWICBT74L42A035V', 'Othello', 'Hamlyn', 'Impiegato', 'Tanzania', 'Pangani', 'Forest', '95');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('QZHJDT68K45I361B', 'Aryn', 'Golling', 'Impiegato', 'Honduras', 'Baja Mar', 'Blaine', '72');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('DNVTBH29S71X928C', 'Christa', 'Oldham', 'Meccanico', 'Thailand', 'Pathum Thani', 'Kensington', '9');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('IOYZHE91D51V715M', 'Randy', 'Saffell', 'Meccanico', 'Indonesia', 'Setono', 'Eggendart', '5648');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('APMCWL81E20I197F', 'Roseanna', 'Vassman', 'Dirigente', 'Russia', 'Solnechnogorsk', 'Towne', '5263');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('WTDZCP70I28O134Q', 'Viola', 'Sulter', 'Impiegato', 'China', 'Shangyong', 'Meadow Vale', '7');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('SOXNKL53G37Y946Y', 'Ave', 'Siemantel', 'Dirigente', 'Poland', 'Pszczyna', 'Manley', '4');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('DWBRJN23Y91H298U', 'Lynnea', 'Le Quesne', 'Meccanico', 'Poland', 'Cielmice', 'Merry', '79');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('RMJTVX23B87U509L', 'Reg', 'Kewish', 'Meccanico', 'Japan', 'Kamimaruko', 'Golf View', '82');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('EFYQSL82C25A429C', 'Leigha', 'Coton', 'Impiegato', 'Peru', 'Urasqui', 'Lakewood', '89540');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('MHRBAL70T50O514A', 'Marena', 'Albert', 'Meccanico', 'Portugal', 'Amadora', 'Evergreen', '45');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('AHECPQ36M17W279C', 'Bernarr', 'Gay', 'Meccanico', 'Honduras', 'El Triunfo de la Cruz', 'Glacier Hill', '40785');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('INXVHS11K30G871X', 'Candice', 'Whinray', 'Meccanico', 'Indonesia', 'Cempa', 'Chinook', '00');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('GSONYP79O27P538Y', 'Greg', 'Ogers', 'Meccanico', 'Russia', 'Kangalassy', 'Kinsman', '28758');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('MAZDYU97D71G905O', 'Edita', 'Trowle', 'Meccanico', 'Poland', 'Lipnik', 'Coleman', '1375');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('QIDUMZ12Y07E399M', 'Ivory', 'Lefeaver', 'Meccanico', 'Portugal', 'Quintas', 'Sunbrook', '7041');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('IMYJBW63Q52F610X', 'Drucie', 'Dalley', 'Meccanico', 'Poland', 'Czechowice-Dziedzice', 'Northwestern', '32294');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('MKQGEX22M93S413X', 'Isidoro', 'Giovannardi', 'Impiegato', 'Russia', 'Kastornoye', 'Banding', '35');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('SYIONR88Y70A893K', 'Margy', 'Tupp', 'Impiegato', 'Democratic Republic of the Congo', 'Buta', 'Debs', '817');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('BXGSHP58P31U870P', 'Jessamyn', 'Heeps', 'Meccanico', 'China', 'Zhangjiahe', 'Tony', '51565');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('DTVECN37B23Z032C', 'Conrad', 'McClymond', 'Dirigente', 'Morocco', 'Tanalt', '3rd', '3');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('DXGNCJ47Z65D161K', 'Elwyn', 'Kestian', 'Meccanico', 'Brazil', 'Aparecida do Taboado', 'Cambridge', '4030');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('CZRPSQ04Z64K115K', 'Odey', 'Durdy', 'Dirigente', 'Argentina', 'Pérez', 'Manufacturers', '1');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('KMOCHU12C59H980B', 'Cory', 'Creaser', 'Meccanico', 'Brazil', 'São Gonçalo do Sapucaí', 'Colorado', '656');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('JYEHXA16K09X859Y', 'Carmine', 'Weatherley', 'Meccanico', 'Portugal', 'Pereiras', 'Glendale', '7');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('KNMGQV35V94C916U', 'Kristal', 'Janko', 'Meccanico', 'Philippines', 'Villa Verde', 'Schlimgen', '43');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('HXELRU57Q85M482L', 'Kerr', 'O'' Driscoll', 'Dirigente', 'Indonesia', 'Langkaplancar', 'Emmet', '99337');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('KLMWSZ71O00A119G', 'Raeann', 'Dwyer', 'Meccanico', 'Indonesia', 'Cileuya', 'Fallview', '6');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('XJTFLQ00O22Z079B', 'Jedd', 'Viger', 'Dirigente', 'Sweden', 'Floda', 'Dexter', '0462');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('OSMBVJ16J62B083M', 'Ced', 'Pawley', 'Meccanico', 'Sweden', 'Borlänge', 'Dexter', '43649');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('WOEFYC08T48X719U', 'Bard', 'Plowes', 'Meccanico', 'Vietnam', 'Cam Lâm', 'Sauthoff', '50722');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('MSJGWX71L84N631E', 'Gusty', 'Geere', 'Dirigente', 'Zambia', 'Mpika', 'Hanson', '7143');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('AFMKQX72L33P459Z', 'Genvieve', 'Sidney', 'Meccanico', 'Indonesia', 'Masu', 'Holy Cross', '702');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('JTNWBA40Q91M944E', 'Dmitri', 'Cantrell', 'Impiegato', 'Indonesia', 'Biris Daja', 'Warner', '8');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('BLUCKA20B66A861Y', 'Luke', 'Benardet', 'Meccanico', 'China', 'Xiayang', 'Bonner', '8274');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('OAGPUY33B64B096J', 'Web', 'Bottoner', 'Impiegato', 'China', 'Jiawu', 'Lakeland', '98724');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('DUJRNT88M89Q100V', 'Shaun', 'Stivens', 'Dirigente', 'Nigeria', 'Gembu', 'Garrison', '0');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('LKEHQC72Z31H581O', 'Gabriel', 'Bake', 'Meccanico', 'Philippines', 'Banag', 'Parkside', '315');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('CMQXWH47E24N990P', 'Craig', 'Cathro', 'Dirigente', 'Nepal', 'Dipayal', 'Burrows', '4535');
insert into Dipendente (CF, Nome, Cognome, Mansione, Nazione, Città, Via, Civico) values ('TJLVZI31W89M512D', 'North', 'Petriello', 'Impiegato', 'Russia', 'Sarmanovo', 'Fieldstone', '5713');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (1, 'Concessionario', 'Tanzania', 'Makungu', '4 Grayhawk Point', '3617');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (2, 'Officina', 'Poland', 'Rakszawa', '8076 East Center', '0');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (3, 'Concessionario', 'Poland', 'Parzęczew', '04650 Southridge Drive', '4773');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (4, 'Concessionario', 'Indonesia', 'Pili', '1 Chinook Pass', '44');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (5, 'Officina', 'Russia', 'Krasnyye Chetai', '6750 Northfield Crossing', '278');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (6, 'Officina', 'Philippines', 'Alangilanan', '48 Melvin Circle', '5');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (7, 'Concessionario', 'China', 'Yushan', '36 Transport Park', '58');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (8, 'Officina', 'China', 'Yangzhuang', '9348 Little Fleur Point', '11660');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (9, 'Officina', 'Japan', 'Tomiya', '04165 Straubel Place', '579');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (10, 'Officina', 'Thailand', 'Det Udom', '848 Jenifer Terrace', '558');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (11, 'Concessionario', 'Indonesia', 'Sijunjung', '5 Bluejay Alley', '3');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (12, 'Officina', 'Russia', 'Bizhbulyak', '9 Village Way', '088');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (13, 'Officina', 'Brazil', 'Solânea', '9 Barnett Court', '0514');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (14, 'Officina', 'China', 'Jingling', '8 Milwaukee Plaza', '536');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (15, 'Officina', 'China', 'Dancheng', '5360 Kinsman Place', '6906');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (16, 'Concessionario', 'Dominican Republic', 'Bánica', '1822 American Ash Court', '059');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (17, 'Officina', 'Madagascar', 'Toliara', '922 Cambridge Point', '7179');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (18, 'Officina', 'Greece', 'Stefanavíkion', '34279 Autumn Leaf Parkway', '606');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (19, 'Concessionario', 'Malaysia', 'Butterworth', '3364 Shopko Place', '82264');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (20, 'Concessionario', 'Poland', 'Pruchnik', '008 Butternut Way', '593');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (21, 'Officina', 'Netherlands', 'Katwijk', '28 Delaware Hill', '4073');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (22, 'Officina', 'Indonesia', 'Sinjai', '12 Independence Way', '033');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (23, 'Officina', 'Serbia', 'Stepojevac', '8 Northridge Terrace', '6');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (24, 'Officina', 'China', 'Basar', '96501 Rieder Trail', '0');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (25, 'Concessionario', 'France', 'Troyes', '60512 Anzinger Place', '70');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (26, 'Concessionario', 'Poland', 'Nowy Staw', '70 Manufacturers Place', '526');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (27, 'Concessionario', 'Poland', 'Dzików Stary', '52 Texas Point', '1932');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (28, 'Officina', 'Russia', 'Priyutovo', '0 Brentwood Pass', '92166');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (29, 'Officina', 'Luxembourg', 'Sandweiler', '5795 6th Alley', '1644');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (30, 'Officina', 'Indonesia', 'Cilongkrangpusaka', '1557 Atwood Drive', '21');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (31, 'Officina', 'Philippines', 'Tiwi', '108 Del Sol Way', '14');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (32, 'Officina', 'North Korea', 'Kapsan-ŭp', '2 Lawn Avenue', '04331');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (33, 'Concessionario', 'Brazil', 'São Bento', '9075 Homewood Plaza', '0674');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (34, 'Officina', 'Marshall Islands', 'Enewetak', '146 Nancy Pass', '066');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (35, 'Officina', 'Indonesia', 'Kebonan', '1702 Talisman Crossing', '3');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (36, 'Concessionario', 'Croatia', 'Bibinje', '29114 Eastwood Way', '7');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (37, 'Officina', 'Brazil', 'Barra do Bugres', '28 Hoepker Park', '9');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (38, 'Officina', 'Afghanistan', 'Khānaqāh', '97676 Cascade Trail', '68');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (39, 'Officina', 'China', 'Macheng', '2934 Rockefeller Way', '10161');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (40, 'Officina', 'Dominican Republic', 'Villa Bisonó', '38 Shoshone Pass', '098');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (41, 'Concessionario', 'Vietnam', 'Thị Trấn Việt Quang', '1 Sunbrook Place', '609');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (42, 'Concessionario', 'Poland', 'Murowana Goślina', '798 Manufacturers Trail', '0');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (43, 'Officina', 'Sweden', 'Tanumshede', '7 Gale Circle', '2');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (44, 'Officina', 'France', 'Saint-Priest-en-Jarez', '9213 Burning Wood Junction', '1359');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (45, 'Officina', 'China', 'Hongshunli', '23322 Donald Plaza', '438');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (46, 'Officina', 'Vietnam', 'Sa Pá', '766 Milwaukee Crossing', '13');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (47, 'Officina', 'Yemen', 'As Sūq al Jadīd', '2 Rowland Pass', '50');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (48, 'Concessionario', 'Botswana', 'Mathakola', '0 Lien Park', '45457');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (49, 'Officina', 'Canada', 'Prince Edward', '715 Emmet Alley', '6613');
insert into Sede (ID, Tipo, Nazione, Città, Via, Civico) values (50, 'Concessionario', 'Poland', 'Zebrzydowice', '77 Northport Court', '48941');
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (1, 'Stagista', 7086.04, 3);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (2, 'Indeterminato', 6923.28, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (3, 'Indeterminato', 107.56, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (4, 'Indeterminato', 8420.52, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (5, 'Determinato', 7771.79, 5);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (6, 'Determinato', 5410.06, 1);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (7, 'Stagista', 7660.38, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (8, 'Indeterminato', 2641.32, 3);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (9, 'Apprendista', 3760.06, 5);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (10, 'Determinato', 138.02, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (11, 'Indeterminato', 9727.58, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (12, 'Indeterminato', 2696.57, 3);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (13, 'Indeterminato', 4966.9, 4);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (14, 'Stagista', 6414.93, 4);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (15, 'Stagista', 8219.32, 1);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (16, 'Indeterminato', 7377.78, 2);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (17, 'Apprendista', 7936.01, 1);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (18, 'Stagista', 9331.95, 1);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (19, 'Stagista', 3771.97, 1);
insert into Contratto (ID, Tipo, Retribuzione_oraria, Livello) values (20, 'Apprendista', 8445.38, 1);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('JUGLEN30F85O361V', '1/3/1995', '11/16/2017', 16, 20);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('GPNTDZ41Y04K627V', '3/2/2010', '11/21/1999', 19, 4);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('UNTEDB88U53M121N', '12/22/2007', '7/7/2013', 20, 49);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('ELCGKP25Y75B126E', '8/4/2020', '9/30/2003', 2, 40);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('VQYTNG77O12Q924C', '9/17/2010', '7/18/2018', 10, 48);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('BZMPKE57O44H236P', '9/29/2001', '10/12/2006', 2, 41);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('GPNSUO77B90I266V', '12/17/1992', '2/7/2022', 3, 17);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('WOUCKJ31B42Z138R', '1/14/2003', '5/9/2016', 18, 27);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('AWOZRX79D11M843H', '4/30/1995', '12/8/2008', 7, 12);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('NAJQKM16I19Y645T', '8/31/2016', '7/13/2009', 10, 39);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('HBLOQK91O47O052F', '1/7/1997', '9/5/1997', 2, 11);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('SBCVOQ67F16L610M', '8/4/2010', '5/2/1993', 20, 18);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('JBZLTG80A87P459T', '8/2/1990', '5/29/1999', 10, 7);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('RYPVDO32P19P264S', '1/22/1992', '8/21/2004', 20, 21);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('FMZNCV23C76C548G', '11/24/1995', '7/1/2012', 14, 45);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('IODLRY04P45R761F', '5/29/2008', '7/25/2008', 8, 38);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('GLAPRE10U69F565I', '3/3/1993', '3/23/2012', 4, 32);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('IKGYSM05R38Y714J', '2/2/2021', '3/5/2015', 13, 32);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('THKCLN23N67C302D', '7/20/2016', '8/17/1996', 19, 42);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('RUFMBO19H15R073N', '11/20/2000', '6/15/2001', 17, 43);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('ZCXMEG04T33K177C', '2/18/1996', '3/19/1992', 14, 39);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('RNUBKT44A80Q175Q', '10/22/2019', '4/28/1996', 5, 12);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('TGOFWM93M47L059B', '10/9/1992', '8/11/2005', 10, 32);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('QVUDWR23J65G431N', '7/21/1991', '3/3/1993', 7, 13);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('XYAEZG37I60I924A', '9/24/2019', '6/15/2014', 7, 50);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('XRWQYB09R71E333Z', '1/23/1992', '5/23/1991', 12, 42);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('WBPMKD74T75M512Z', '2/10/2015', '3/13/2020', 9, 21);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('DXPLOI32X33S572A', '3/22/2015', '2/9/2013', 2, 48);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('SUFIBQ59V47L902R', '10/26/2018', '8/22/2016', 5, 18);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('VXPBTE87M75N903G', '9/24/1993', '7/18/2012', 16, 42);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('ZYSOKL54Z09G752H', '6/18/1999', '4/16/2001', 16, 28);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('BITSMR75R59O477I', '9/21/1998', '9/2/2008', 12, 32);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('IAPMLJ18G58T662Z', '12/23/1998', '5/30/2011', 15, 50);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('PXVCRT57R97A851H', '7/25/2020', '2/21/1997', 7, 22);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('XCTDLF62C18K046Q', '5/8/2010', '12/22/1997', 7, 24);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('HKFXQN28Q57M182M', '8/21/2021', '4/4/2021', 18, 27);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('FBIPEH32X35Q672K', '4/26/2001', '10/8/1993', 11, 3);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('DAETNF20I93M563N', '2/20/2000', '6/7/2006', 10, 49);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('AYHZSJ78I63P195Z', '3/18/1998', '3/23/1992', 10, 23);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('EQTYDL73Y78V272Z', '11/22/2014', '10/22/1993', 11, 29);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('GUIHLC42G68D787H', '10/31/2001', '10/5/2017', 14, 26);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('YPJRXW95A04W105Y', '1/9/2014', '3/21/2006', 8, 5);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('SHXYGT66W50G278V', '9/20/2016', '9/26/1991', 10, 36);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('ALYWNE38S80H050A', '1/9/2012', '8/22/2011', 7, 3);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('FZCGXK24Z95A613A', '7/12/1995', '7/11/2008', 17, 6);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('MSJOPX25X17O852X', '1/18/1998', '8/2/2020', 7, 27);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('GZYITU49X98U665K', '4/23/2001', '8/11/2011', 2, 25);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('KQPYRG43O29C127E', '12/2/1997', '2/27/2019', 3, 3);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('CZALQG69P25J826Y', '5/24/2019', '11/13/2013', 7, 2);
insert into Impiego_passato (Dipendente, Inizio, Fine, Contratto, Sede) values ('QEVMYU82N66Z092N', '12/14/2019', '9/13/2015', 7, 32);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1990-06-24', 17, 'DNVTBH29S71X928C', 3);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-09-20', 29, 'RTIBLG42H44E431C', 15);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2002-01-28', 45, 'LKEHQC72Z31H581O', 19);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1996-03-01', 14, 'WTDZCP70I28O134Q', 5);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2009-11-16', 22, 'HXELRU57Q85M482L', 9);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2018-04-28', 3, 'IOYZHE91D51V715M', 3);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1998-12-09', 4, 'RYFWZO66L14L336W', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-10-28', 2, 'WOEFYC08T48X719U', 10);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1992-04-28', 42, 'IKGRTQ94H83A629Q', 18);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-02-28', 36, 'JYEHXA16K09X859Y', 13);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1998-01-10', 32, 'APMCWL81E20I197F', 6);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1999-09-18', 18, 'QZHJDT68K45I361B', 11);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2009-06-12', 14, 'QWICBT74L42A035V', 2);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-10-02', 44, 'TJLVZI31W89M512D', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2003-07-25', 44, 'SOXNKL53G37Y946Y', 8);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2020-04-01', 3, 'KMOCHU12C59H980B', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2000-05-26', 20, 'NUYBQZ04M81Z337X', 8);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1991-03-09', 11, 'IMYJBW63Q52F610X', 11);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-07-19', 40, 'MKQGEX22M93S413X', 19);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1995-03-31', 16, 'TIPWMQ35E19R424U', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1991-03-12', 12, 'KLMWSZ71O00A119G', 5);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2002-04-08', 2, 'INXVHS11K30G871X', 4);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2021-06-04', 27, 'DUJRNT88M89Q100V', 4);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2003-09-06', 19, 'RMJTVX23B87U509L', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2018-05-31', 11, 'EFYQSL82C25A429C', 16);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2011-11-25', 27, 'BLUCKA20B66A861Y', 18);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2019-08-14', 2, 'GSONYP79O27P538Y', 2);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2003-12-04', 19, 'JTNWBA40Q91M944E', 19);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2015-09-12', 21, 'VOBNUF63N53R914Y', 20);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2009-01-03', 47, 'BXGSHP58P31U870P', 9);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1996-08-28', 6, 'AHECPQ36M17W279C', 20);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2017-11-02', 24, 'ZSCQHT02T02K420Z', 5);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1990-11-26', 40, 'UXAWKM77U99Q663Y', 20);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2021-12-03', 32, 'AFMKQX72L33P459Z', 3);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2006-01-19', 31, 'XJTFLQ00O22Z079B', 11);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2004-10-09', 30, 'MAZDYU97D71G905O', 7);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2000-12-09', 42, 'QIDUMZ12Y07E399M', 15);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2002-01-10', 45, 'MHRBAL70T50O514A', 4);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1997-12-20', 48, 'CMQXWH47E24N990P', 6);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2001-08-05', 50, 'SYIONR88Y70A893K', 17);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1994-07-19', 21, 'DTVECN37B23Z032C', 10);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2005-03-19', 19, 'DWBRJN23Y91H298U', 18);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2012-08-07', 41, 'DXGNCJ47Z65D161K', 10);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2019-12-18', 38, 'CZRPSQ04Z64K115K', 9);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1992-10-12', 14, 'KNMGQV35V94C916U', 19);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2009-02-06', 41, 'GEQMOH78M92C221Q', 14);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2012-03-24', 23, 'OSMBVJ16J62B083M', 7);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1998-02-14', 46, 'KYWTIC72Y14C857P', 2);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('1993-12-10', 14, 'MSJGWX71L84N631E', 2);
insert into Impiego_corrente (inizio, sede, dipendente, contratto) values ('2022-05-02', 23, 'OAGPUY33B64B096J', 19);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Continental GT', 'Bentley', 2007);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('tC', 'Scion', 2005);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('MDX', 'Acura', 2001);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Allroad', 'Audi', 2004);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Prius', 'Toyota', 2001);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('CX', 'Citroën', 1989);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Element', 'Honda', 2009);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Impreza', 'Subaru', 2002);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Dakota Club', 'Dodge', 2006);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('S-Series', 'Saturn', 1997);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Altima', 'Nissan', 1993);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Rabbit', 'Volkswagen', 2010);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Mini Cooper', 'Austin', 1964);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Mazda3', 'Mazda', 2006);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Sedona', 'Kia', 2006);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Challenger', 'Mitsubishi', 2002);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Camry', 'Toyota', 2010);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Q7', 'Audi', 2011);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('2500', 'Chevrolet', 2000);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('62', 'Maybach', 2008);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Ramcharger', 'Dodge', 1992);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('ZX2', 'Ford', 2002);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Electra', 'Buick', 1990);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('Hemisfear', 'Foose', 2007);
insert into Modello (Nome, Costruttore, Inizio_produzione) values ('S10', 'Chevrolet', 1995);
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('03924848846491739', '62585', '2021-08-13', 'Impreza');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('89141317436394174', '801060', '2021-07-06', '62');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('44935670213409917', '04771', '2021-06-13', 'Q7');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('06684520447861656', '45424', '2021-12-26', 'Dakota Club');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('23570811509829180', '506523', '2021-07-11', 'CX');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('96947343430967185', '5410', '2021-11-27', 'Continental GT');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('74845349479592423', '430780', '2021-06-12', 'Mazda3');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('53486300705779394', '468599', '2021-11-04', 'Altima');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('63516936810994252', '01096', '2021-06-28', 'Electra');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('12051972772547648', '3443', '2021-09-26', 'Sedona');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('96025942524286626', '2530', '2021-10-09', 'S-Series');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('17117028227914201', '0131', '2021-05-30', 'MDX');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('32911759807728585', '1288', '2022-02-25', 'Dakota Club');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('76995480627289460', '239197', '2022-04-02', 'Ramcharger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('39595018999892336', '0978', '2021-12-31', '2500');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('15326604829361672', '405277', '2021-11-15', 'Challenger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('52031205778360962', '520807', '2021-06-22', 'Hemisfear');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('13138061691406232', '63716', '2022-05-22', '2500');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('84339690673705317', '49352', '2022-05-24', 'Challenger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('77993546816616900', '873502', '2022-03-08', 'Altima');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('08679574122704772', '989936', '2021-10-09', 'Challenger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('54912819165089017', '3651', '2022-05-07', 'MDX');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('10195789264873619', '5419', '2021-12-06', 'Q7');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('66133296606607658', '398315', '2021-11-24', '2500');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('59842968371349242', '435576', '2021-07-08', 'Impreza');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('93873922861459516', '677221', '2022-05-09', 'Ramcharger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('78897607477092755', '2131', '2022-03-18', 'Ramcharger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('24329816399901637', '47950', '2022-02-16', 'Prius');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('47713622361890662', '066122', '2021-12-25', 'S10');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('78714601488387367', '459538', '2021-10-05', 'Dakota Club');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('30532332324139565', '00932', '2021-09-24', 'Impreza');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('31568508821426151', '877912', '2022-04-30', 'Rabbit');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('01222922563132204', '9505', '2021-12-12', 'Element');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('11796397017898593', '5930', '2021-09-06', 'Mini Cooper');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('90422686218009673', '3596', '2021-08-16', 'tC');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('97903522333532802', '5460', '2022-04-19', 'Mazda3');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('05602918451878183', '623186', '2022-01-28', 'S10');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('75656747405344464', '243000', '2021-08-14', 'ZX2');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('13258870073448272', '122623', '2021-09-01', 'tC');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('07053857691575454', '498294', '2021-11-18', 'Camry');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('31100014245672983', '33873', '2021-10-11', 'Ramcharger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('71358214412968272', '88763', '2021-10-27', '2500');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('65126626430782078', '605199', '2022-05-07', 'Rabbit');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('45582152329484255', '66640', '2022-01-24', 'Q7');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('62349189462014558', '80831', '2021-07-21', 'Continental GT');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('33584618494423495', '53279', '2021-07-10', 'Q7');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('13046075699834121', '522313', '2021-12-22', 'Sedona');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('83593848954955960', '19049', '2021-07-13', 'Q7');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('05544557624278137', '290726', '2021-10-25', 'Challenger');
insert into Veicolo (Telaio, Prezzo, Anno, Modello) values ('50591981069681520', '860126', '2021-06-20', 'Rabbit');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('03924848846491739', 'KQ515LM', '3000');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('89141317436394174', 'IJ901QC', '055830');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('44935670213409917', 'AO182HN', '010');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('06684520447861656', 'CU063RU', '902');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('23570811509829180', 'JH662OP', '27700');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('96947343430967185', 'DG889HB', '2107');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('74845349479592423', 'KJ095WA', '0053');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('53486300705779394', 'OY837ZQ', '3400');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('63516936810994252', 'HZ236BW', '900');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('12051972772547648', 'LE644EY', '000');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('96025942524286626', 'OR082SG', '9001');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('17117028227914201', 'QV572MC', '052417');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('32911759807728585', 'BL913SF', '060');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('76995480627289460', 'ZD487UE', '090001');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('39595018999892336', 'KO130HA', '0508');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('15326604829361672', 'LA156ME', '803580');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('52031205778360962', 'WM828NP', '000006');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('13138061691406232', 'BM392QC', '02300');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('84339690673705317', 'WJ498MK', '00075');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('77993546816616900', 'PG050QO', '700007');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('08679574122704772', 'ZE233WG', '000');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('54912819165089017', 'KO835PG', '003900');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('10195789264873619', 'CO423FZ', '380081');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('66133296606607658', 'EM791HU', '074');
insert into Veicolo_immatricolato (Telaio, Targa, KM) values ('59842968371349242', 'DT446FZ', '60509');
insert into Intervento (Id, Veicolo, Officina) values (1, '03924848846491739', 22);
insert into Intervento (Id, Veicolo, Officina) values (2, '89141317436394174', 18);
insert into Intervento (Id, Veicolo, Officina) values (3, '44935670213409917', 47);
insert into Intervento (Id, Veicolo, Officina) values (4, '06684520447861656', 31);
insert into Intervento (Id, Veicolo, Officina) values (5, '23570811509829180', 47);
insert into Intervento (Id, Veicolo, Officina) values (6, '96947343430967185', 43);
insert into Intervento (Id, Veicolo, Officina) values (7, '74845349479592423', 28);
insert into Intervento (Id, Veicolo, Officina) values (8, '53486300705779394', 18);
insert into Intervento (Id, Veicolo, Officina) values (9, '63516936810994252', 17);
insert into Intervento (Id, Veicolo, Officina) values (10, '12051972772547648', 21);
insert into Intervento (Id, Veicolo, Officina) values (11, '96025942524286626', 45);
insert into Intervento (Id, Veicolo, Officina) values (12, '17117028227914201', 30);
insert into Intervento (Id, Veicolo, Officina) values (13, '32911759807728585', 24);
insert into Intervento (Id, Veicolo, Officina) values (14, '76995480627289460', 30);
insert into Intervento (Id, Veicolo, Officina) values (15, '39595018999892336', 37);
insert into Intervento (Id, Veicolo, Officina) values (16, '15326604829361672', 28);
insert into Intervento (Id, Veicolo, Officina) values (17, '52031205778360962', 31);
insert into Intervento (Id, Veicolo, Officina) values (18, '13138061691406232', 39);
insert into Intervento (Id, Veicolo, Officina) values (19, '84339690673705317', 21);
insert into Intervento (Id, Veicolo, Officina) values (20, '77993546816616900', 10);
insert into Intervento (Id, Veicolo, Officina) values (21, '08679574122704772', 47);
insert into Intervento (Id, Veicolo, Officina) values (22, '54912819165089017', 13);
insert into Intervento (Id, Veicolo, Officina) values (23, '10195789264873619', 32);
insert into Intervento (Id, Veicolo, Officina) values (24, '66133296606607658', 10);
insert into Intervento (Id, Veicolo, Officina) values (25, '59842968371349242', 44);
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (1, 1, 864.78, '10', '2022-01-18');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (2, 2, 7567.39, '10', '2021-09-11');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (3, 3, 1125.7, '15', '2021-12-20');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (4, 4, 7774.91, '22', '2022-01-18');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (5, 5, 2329.73, '22', '2021-08-23');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (6, 6, 4801.18, '10', '2021-07-24');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (7, 7, 1990.48, '10', '2021-10-03');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (8, 8, 6867.13, '10', '2021-09-06');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (9, 9, 4363.78, '22', '2022-04-15');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (10, 10, 4418.95, '10', '2021-10-02');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (11, 11, 7825.26, '22', '2021-12-16');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (12, 12, 9182.83, '10', '2021-12-03');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (13, 13, 7118.43, '22', '2021-06-04');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (14, 14, 6333.59, '10', '2021-11-05');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (15, 15, 6727.83, '10', '2022-05-08');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (16, 16, 8317.28, '10', '2022-04-20');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (17, 17, 6850.57, '15', '2021-09-14');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (18, 18, 3528.8, '10', '2022-01-05');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (19, 19, 2469.15, '22', '2021-11-14');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (20, 20, 6991.56, '10', '2021-12-11');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (21, 21, 5596.82, '22', '2021-07-28');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (22, 22, 1702.94, '22', '2021-07-02');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (23, 23, 5039.11, '15', '2021-06-28');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (24, 24, 2836.42, '10', '2021-09-23');
insert into Fattura (numero, Intervento, Netto, Iva, Data) values (25, 25, 5866.58, '22', '2021-06-30');
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (1, 'KNMGQV35V94C916U', 655);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (25, 'XJTFLQ00O22Z079B', 899);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (3, 'GSONYP79O27P538Y', 968);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (24, 'WTDZCP70I28O134Q', 821);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (5, 'KLMWSZ71O00A119G', 902);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (23, 'XJTFLQ00O22Z079B', 921);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (7, 'MAZDYU97D71G905O', 599);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (22, 'GSONYP79O27P538Y', 151);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (9, 'TJLVZI31W89M512D', 117);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (21, 'CMQXWH47E24N990P', 392);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (11, 'DXGNCJ47Z65D161K', 634);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (20, 'XJTFLQ00O22Z079B', 349);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (13, 'INXVHS11K30G871X', 967);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (19, 'MSJGWX71L84N631E', 915);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (8, 'QZHJDT68K45I361B', 772);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (18, 'DUJRNT88M89Q100V', 973);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (9, 'INXVHS11K30G871X', 819);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (17, 'IMYJBW63Q52F610X', 448);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (10, 'JYEHXA16K09X859Y', 408);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (16, 'QZHJDT68K45I361B', 187);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (11, 'MSJGWX71L84N631E', 978);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (15, 'UXAWKM77U99Q663Y', 527);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (12, 'IKGRTQ94H83A629Q', 502);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (14, 'DUJRNT88M89Q100V', 397);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (13, 'WOEFYC08T48X719U', 906);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (14, 'INXVHS11K30G871X', 855);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (14, 'KMOCHU12C59H980B', 980);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (12, 'SOXNKL53G37Y946Y', 76);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (15, 'JYEHXA16K09X859Y', 841);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (11, 'XJTFLQ00O22Z079B', 415);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (16, 'MAZDYU97D71G905O', 685);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (10, 'ZSCQHT02T02K420Z', 566);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (17, 'DNVTBH29S71X928C', 10);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (9, 'BXGSHP58P31U870P', 399);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (18, 'MKQGEX22M93S413X', 752);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (8, 'SYIONR88Y70A893K', 162);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (19, 'BXGSHP58P31U870P', 128);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (7, 'CZRPSQ04Z64K115K', 384);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (20, 'JYEHXA16K09X859Y', 946);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (6, 'DTVECN37B23Z032C', 418);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (21, 'DNVTBH29S71X928C', 66);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (5, 'IKGRTQ94H83A629Q', 124);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (22, 'OSMBVJ16J62B083M', 9);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (4, 'WOEFYC08T48X719U', 648);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (23, 'BXGSHP58P31U870P', 922);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (3, 'ZSCQHT02T02K420Z', 514);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (24, 'GSONYP79O27P538Y', 856);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (2, 'QZHJDT68K45I361B', 106);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (25, 'NUYBQZ04M81Z337X', 170);
insert into Intervento_dipendente (ID, CF, Ore_impiegate) values (1, 'ZSCQHT02T02K420Z', 66);
insert into Optional (Codice, Categoria, Fornitore) values ('JLNUDFYSOQVAGCB', 'Head-up Display', 'GMC');
insert into Optional (Codice, Categoria, Fornitore) values ('NRGAKTLIOXWEJPF', 'Head-up Display', 'Cadillac');
insert into Optional (Codice, Categoria, Fornitore) values ('FDNIREQGHXUMTVO', 'Telecamera 360', 'Volkswagen');
insert into Optional (Codice, Categoria, Fornitore) values ('MZEYUWVBTRKJIPS', 'Head-up Display', 'Hyundai');
insert into Optional (Codice, Categoria, Fornitore) values ('VDQGZXCFELWOJYS', 'Telecamera 360', 'Pontiac');
insert into Optional (Codice, Categoria, Fornitore) values ('GPTSAJKVXQIMELD', 'Head-up Display', 'Volvo');
insert into Optional (Codice, Categoria, Fornitore) values ('EGSRMAKJPIDWXZU', 'Telecamera 360', 'Volkswagen');
insert into Optional (Codice, Categoria, Fornitore) values ('NYZQPBJCDFTIKHG', 'Head-up Display', 'Bentley');
insert into Optional (Codice, Categoria, Fornitore) values ('VZRCBYQLKEJHAIN', 'Telecamera 360', 'Mitsubishi');
insert into Optional (Codice, Categoria, Fornitore) values ('PRKICFTJGUQMEAY', 'Head-up Display', 'Chevrolet');
insert into Optional (Codice, Categoria, Fornitore) values ('BNLDAMEVOXQFSIT', 'Mantenimento corsia', 'Dodge');
insert into Optional (Codice, Categoria, Fornitore) values ('KXQVAFMERTGYUDJ', 'Telecamera 360', 'Volkswagen');
insert into Optional (Codice, Categoria, Fornitore) values ('PBZHMJXWEGCNLSR', 'Telecamera 360', 'Buick');
insert into Optional (Codice, Categoria, Fornitore) values ('UKDIRLJBWQTNMYO', 'Guida Autonoma', 'Infiniti');
insert into Optional (Codice, Categoria, Fornitore) values ('GCDLBHYQVZJTRPF', 'Mantenimento corsia', 'Jeep');
insert into Optional (Codice, Categoria, Fornitore) values ('QWAJFVDOKUNBIZE', 'Telecamera 360', 'Mitsubishi');
insert into Optional (Codice, Categoria, Fornitore) values ('LIPMSONHXJWEDGT', 'Cruise Controll Adattivo', 'Nissan');
insert into Optional (Codice, Categoria, Fornitore) values ('JAKLBSXDZEUPVOF', 'Head-up Display', 'Mazda');
insert into Optional (Codice, Categoria, Fornitore) values ('ALVZIRWCJOTGKDU', 'Telecamera 360', 'Isuzu');
insert into Optional (Codice, Categoria, Fornitore) values ('ZXJCGUQKDPWOSNE', 'Telecamera 360', 'Ford');
insert into Optional (Codice, Categoria, Fornitore) values ('GTBEKCRVIUMLOSF', 'Cruise Controll Adattivo', 'Pontiac');
insert into Optional (Codice, Categoria, Fornitore) values ('BDHTFKAZWYMVRLS', 'Head-up Display', 'Daewoo');
insert into Optional (Codice, Categoria, Fornitore) values ('LEHBYAUXSTRZGOI', 'Head-up Display', 'Nissan');
insert into Optional (Codice, Categoria, Fornitore) values ('QVIGBHFNSRJTKDA', 'Telecamera 360', 'Toyota');
insert into Optional (Codice, Categoria, Fornitore) values ('XDLMQPECIOFJTGA', 'Telecamera 360', 'Ford');
insert into Optional (Codice, Categoria, Fornitore) values ('DWGLOQNHYACVJBX', 'Telecamera 360', 'Chevrolet');
insert into Optional (Codice, Categoria, Fornitore) values ('KAEPDTXVHRZJGOC', 'Head-up Display', 'Saab');
insert into Optional (Codice, Categoria, Fornitore) values ('UXZCLMKPFHRYQVI', 'Telecamera 360', 'Pontiac');
insert into Optional (Codice, Categoria, Fornitore) values ('IANVGWOJUKLCREP', 'Head-up Display', 'Mitsubishi');
insert into Optional (Codice, Categoria, Fornitore) values ('VXZYLSCGEQPURJH', 'Cruise Controll Adattivo', 'Pontiac');
insert into Optional (Codice, Categoria, Fornitore) values ('RHMOKWNVLAZJSIU', 'Telecamera 360', 'Toyota');
insert into Optional (Codice, Categoria, Fornitore) values ('LVFIBSGPJRTUHWD', 'Head-up Display', 'Chevrolet');
insert into Optional (Codice, Categoria, Fornitore) values ('ULMVWEIOCPRDKTH', 'Cruise Controll Adattivo', 'Land Rover');
insert into Optional (Codice, Categoria, Fornitore) values ('YOPUWHISJCEXLVQ', 'Telecamera 360', 'Dodge');
insert into Optional (Codice, Categoria, Fornitore) values ('VFEGMDQYZTRWBSL', 'Head-up Display', 'Nissan');
insert into Optional (Codice, Categoria, Fornitore) values ('CDNGTFRMSLAZBQE', 'Guida Autonoma', 'Hyundai');
insert into Optional (Codice, Categoria, Fornitore) values ('YNTWSEVLFROXAGD', 'Telecamera 360', 'Fillmore');
insert into Optional (Codice, Categoria, Fornitore) values ('PDZOXTCYUVNKHSF', 'Telecamera 360', 'Dodge');
insert into Optional (Codice, Categoria, Fornitore) values ('HFQPVJCATZBWYDX', 'Telecamera 360', 'Nissan');
insert into Optional (Codice, Categoria, Fornitore) values ('WYUCONSRVGTXDJK', 'Guida Autonoma', 'Pontiac');
insert into Optional (Codice, Categoria, Fornitore) values ('SLDEPIHZWTXOJVM', 'Telecamera 360', 'Infiniti');
insert into Optional (Codice, Categoria, Fornitore) values ('VTFSQHRKUMBOXAC', 'Guida Autonoma', 'Mazda');
insert into Optional (Codice, Categoria, Fornitore) values ('TQXSNMDVRBFKPAE', 'Head-up Display', 'Ford');
insert into Optional (Codice, Categoria, Fornitore) values ('LTVBKANXDYIQECU', 'Telecamera 360', 'Mercedes-Benz');
insert into Optional (Codice, Categoria, Fornitore) values ('CZEMYLSTOQIHWUP', 'Cruise Controll Adattivo', 'Acura');
insert into Optional (Codice, Categoria, Fornitore) values ('TVXYUSQNMPERLBH', 'Telecamera 360', 'Mercedes-Benz');
insert into Optional (Codice, Categoria, Fornitore) values ('IZDCPTXSAMFJBYE', 'Telecamera 360', 'Jeep');
insert into Optional (Codice, Categoria, Fornitore) values ('NQYEWHCPDSRLXMK', 'Head-up Display', 'Jeep');
insert into Optional (Codice, Categoria, Fornitore) values ('UOIAZMELSDVXJCP', 'Telecamera 360', 'Nissan');
insert into Optional (Codice, Categoria, Fornitore) values ('RBACHGKVTZFEWJQ', 'Telecamera 360', 'Chevrolet');
insert into Optional_base (Modello, Optional) values ('Altima', 'PRKICFTJGUQMEAY');
insert into Optional_base (Modello, Optional) values ('Mini Cooper', 'BNLDAMEVOXQFSIT');
insert into Optional_base (Modello, Optional) values ('Mazda3', 'KXQVAFMERTGYUDJ');
insert into Optional_base (Modello, Optional) values ('Sedona', 'PBZHMJXWEGCNLSR');
insert into Optional_base (Modello, Optional) values ('Challenger', 'NQYEWHCPDSRLXMK');
insert into Optional_base (Modello, Optional) values ('Q7', 'UOIAZMELSDVXJCP');
insert into Optional_aggiuntivi (Veicolo, Optional, Prezzo) values ('24329816399901637', 'QVIGBHFNSRJTKDA', 100.00);
insert into Optional_aggiuntivi (Veicolo, Optional, Prezzo) values ('47713622361890662', 'XDLMQPECIOFJTGA', 100.00);
insert into Optional_aggiuntivi (Veicolo, Optional, Prezzo) values ('78714601488387367', 'DWGLOQNHYACVJBX', 100.00);
insert into Optional_aggiuntivi (Veicolo, Optional, Prezzo) values ('30532332324139565', 'KAEPDTXVHRZJGOC', 100.00);
insert into Optional_aggiuntivi (Veicolo, Optional, Prezzo) values ('31568508821426151', 'UXZCLMKPFHRYQVI', 100.00);
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31100014245672983', 23, 'JRBVIQ23P17A981T', '2022-02-07');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13258870073448272', 22, 'AXOHJG07F50J933M', '2021-09-23');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('05544557624278137', 20, 'MTPDKW50E99C357T', '2021-05-26');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('53486300705779394', 20, 'NDLUCQ13W52W823O', '2022-04-15');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('45582152329484255', 50, 'STHYZC13X52S041C', '2022-05-06');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('62349189462014558', 3, 'DAKRMQ02Q92T379V', '2021-10-07');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31100014245672983', 22, 'DGNEVR17W09Y796O', '2021-08-19');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('15326604829361672', 27, 'MLFHXV46E30O654L', '2021-07-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('74845349479592423', 20, 'MRFVNW64L86M192G', '2021-10-22');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('71358214412968272', 49, 'OUBDSQ40E91N474L', '2021-09-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('50591981069681520', 48, 'ELTAIO04A49G866C', '2022-03-21');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('89141317436394174', 32, 'XLHORE99Q56K969T', '2021-12-07');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('44935670213409917', 14, 'DAKRMQ02Q92T379V', '2022-04-23');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('12051972772547648', 12, 'OUBDSQ40E91N474L', '2021-06-02');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('03924848846491739', 15, 'OJCXYS67J46I803L', '2022-01-23');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('11796397017898593', 45, 'ZKAHSL01P63L002M', '2021-09-12');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('17117028227914201', 5, 'PJDYWL58U69J587W', '2021-09-17');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('50591981069681520', 26, 'YBORFQ16W63N987T', '2021-10-14');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('89141317436394174', 25, 'ISDBTV10D86U364I', '2021-08-17');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('08679574122704772', 39, 'XLHORE99Q56K969T', '2021-06-22');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31100014245672983', 30, 'NVEKYX27O37F254S', '2022-04-13');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('05544557624278137', 42, 'OJCXYS67J46I803L', '2021-11-28');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('12051972772547648', 46, 'AXOHJG07F50J933M', '2021-06-20');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31100014245672983', 19, 'OJCXYS67J46I803L', '2021-12-08');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('08679574122704772', 40, 'ZWPAGM10M08D347T', '2022-03-21');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('90422686218009673', 40, 'ASEONX67S98M916E', '2021-11-05');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13046075699834121', 32, 'HKTIWD87M28H697V', '2022-01-14');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('33584618494423495', 25, 'PQGELO38P79B350H', '2022-03-01');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('24329816399901637', 17, 'OUBDSQ40E91N474L', '2022-03-26');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('59842968371349242', 24, 'EWKQGZ17F74X222N', '2021-12-14');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('39595018999892336', 25, 'WXPBUA62P61G788N', '2022-01-16');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13258870073448272', 31, 'JRBVIQ23P17A981T', '2021-10-25');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('90422686218009673', 32, 'MHAQFI37H28U661I', '2021-06-22');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('44935670213409917', 41, 'AVCOUE99U68N227I', '2022-03-20');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('32911759807728585', 14, 'AVGOIN39B71A372L', '2022-02-06');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('75656747405344464', 22, 'NDLUCQ13W52W823O', '2021-08-31');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('17117028227914201', 37, 'OJCXYS67J46I803L', '2021-09-15');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('24329816399901637', 10, 'JULGBD78U32G348M', '2021-11-05');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('71358214412968272', 11, 'FYAKJL54I85Q628W', '2022-01-20');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('11796397017898593', 28, 'EWKQGZ17F74X222N', '2021-12-30');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('24329816399901637', 29, 'FYAKJL54I85Q628W', '2022-01-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('08679574122704772', 21, 'STHYZC13X52S041C', '2022-03-29');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('07053857691575454', 5, 'ZOLEIK97I41Z558Y', '2021-09-08');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('62349189462014558', 35, 'XLHORE99Q56K969T', '2021-08-21');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('66133296606607658', 12, 'MHAQFI37H28U661I', '2021-09-02');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13258870073448272', 30, 'YBORFQ16W63N987T', '2021-11-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('07053857691575454', 40, 'JLVAPQ38T41A891P', '2021-08-19');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('84339690673705317', 4, 'XLHORE99Q56K969T', '2021-11-20');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13258870073448272', 22, 'DSYCFB64D98Y457D', '2022-02-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('78714601488387367', 41, 'AVGOIN39B71A372L', '2021-12-09');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('05602918451878183', 2, 'OZUGJV98G14U458V', '2022-02-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('47713622361890662', 16, 'RZEBKN50I75E721Z', '2022-02-26');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('78714601488387367', 25, 'ADROVL45T44M509D', '2021-11-28');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13138061691406232', 14, 'DGNEVR17W09Y796O', '2022-04-22');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('90422686218009673', 12, 'ZOLEIK97I41Z558Y', '2021-06-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('24329816399901637', 44, 'PJDYWL58U69J587W', '2021-10-11');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('24329816399901637', 36, 'MRFVNW64L86M192G', '2021-12-29');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('74845349479592423', 29, 'NARVQT95X88Z566S', '2021-09-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('44935670213409917', 17, 'DSYCFB64D98Y457D', '2022-02-20');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31100014245672983', 42, 'HKTIWD87M28H697V', '2021-09-26');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('93873922861459516', 25, 'NARVQT95X88Z566S', '2022-02-19');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('44935670213409917', 38, 'DPLNGW14F22B788P', '2022-05-14');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('12051972772547648', 42, 'MRFVNW64L86M192G', '2021-10-17');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('76995480627289460', 37, 'PQGELO38P79B350H', '2022-02-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('54912819165089017', 32, 'PJDYWL58U69J587W', '2022-05-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('12051972772547648', 29, 'ASEONX67S98M916E', '2022-01-25');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13138061691406232', 36, 'RZEBKN50I75E721Z', '2021-07-29');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('96025942524286626', 17, 'DGNEVR17W09Y796O', '2022-01-21');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('78714601488387367', 28, 'AVGOIN39B71A372L', '2021-06-25');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13138061691406232', 29, 'STHYZC13X52S041C', '2021-07-24');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('63516936810994252', 44, 'ISDBTV10D86U364I', '2022-02-17');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('50591981069681520', 7, 'AVCOUE99U68N227I', '2021-12-22');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('07053857691575454', 22, 'DGNEVR17W09Y796O', '2021-08-15');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('31568508821426151', 6, 'ZKAHSL01P63L002M', '2021-08-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('45582152329484255', 42, 'ELTAIO04A49G866C', '2021-09-21');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('93873922861459516', 22, 'DSYCFB64D98Y457D', '2021-08-15');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('59842968371349242', 16, 'TCRFZS73L27N235Z', '2021-06-27');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('06684520447861656', 16, 'NARVQT95X88Z566S', '2021-10-07');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('96947343430967185', 21, 'INDCTE42Y17P762V', '2021-09-04');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('74845349479592423', 12, 'EWKQGZ17F74X222N', '2021-06-24');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('33584618494423495', 28, 'PQGELO38P79B350H', '2021-06-13');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13046075699834121', 28, 'ZWPAGM10M08D347T', '2021-11-28');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('65126626430782078', 49, 'DSYCFB64D98Y457D', '2022-01-25');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('06684520447861656', 10, 'HKTIWD87M28H697V', '2021-09-05');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('54912819165089017', 46, 'VYMPFN25U94Y729E', '2022-03-02');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('11796397017898593', 3, 'ZOLEIK97I41Z558Y', '2022-03-29');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('90422686218009673', 47, 'MHAQFI37H28U661I', '2022-01-13');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('65126626430782078', 46, 'EWKQGZ17F74X222N', '2022-05-04');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('05544557624278137', 18, 'YBORFQ16W63N987T', '2021-08-07');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('52031205778360962', 15, 'JLVAPQ38T41A891P', '2022-04-28');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('32911759807728585', 6, 'EDPANR00I12A043H', '2021-07-08');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('71358214412968272', 3, 'ELTAIO04A49G866C', '2022-04-08');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('32911759807728585', 31, 'AVCOUE99U68N227I', '2022-03-08');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('08679574122704772', 13, 'MRFVNW64L86M192G', '2022-03-15');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('13046075699834121', 17, 'NARVQT95X88Z566S', '2022-01-03');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('44935670213409917', 48, 'ISDBTV10D86U364I', '2022-01-11');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('96025942524286626', 27, 'TCRFZS73L27N235Z', '2022-05-04');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('23570811509829180', 18, 'PJDYWL58U69J587W', '2022-02-25');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('15326604829361672', 39, 'OZUGJV98G14U458V', '2022-03-24');
insert into Vendita (Veicolo, Concessionario, Acquirente, Data) values ('83593848954955960', 25, 'TCRFZS73L27N235Z', '2022-04-22');
