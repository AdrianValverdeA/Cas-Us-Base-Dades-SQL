# Sistema de Monitoratge de Pacients Crítics a la UCI

## Descripció del Projecte
Aquest projecte consisteix en un sistema de gestió i monitoratge de pacients crítics a la Unitat de Cures Intensives (UCI). El sistema està dissenyat per gestionar informació clínica, tractaments, protocols mèdics i visites dels pacients, amb l'objectiu de millorar l'eficiència i la qualitat de l'atenció mèdica.

## Objectius del Projecte
El sistema té com a objectiu principal **millorar la gestió i el tractament dels pacients crítics a la UCI** mitjançant:  

**Centralització de dades clíniques**:  
   - Registrar de manera estructurada la informació dels pacients (malalties, visites, medicacions, etc.).  
   - Facilitar l'accés ràpid a historials mèdics per al personal sanitari.  

**Optimització de protocols mèdics**:  
   - Automatitzar l'assignació de protocols segons el ritme d’aturada del pacient (desfibril·lable/no desfibril·lable).  
   - Garantir el seguiment precís dels cicles d’intervenció (temps, medicaments administrats, etc.).  

**Millora de la coordinació de l'equip**:  
   - Assignar rols específics al personal (Team Leader, TCAI) durant les urgències.  
   - Registrar totes les accions mèdiques per a una auditoria posterior.  

**Assegurar la traçabilitat**:  
   - Documentar tots els esdeveniments clínics (ingressos, sortides, canvis de protocol).  
   - Vincular medicacions i dosi al pes/edat del pacient per evitar errors.  

## Objectius d'Aprenentatge  

Aquest projecte està dissenyat per consolidar i aplicar coneixements en les següents àrees tècniques:  

###**Modelatge de Bases de Dades**  
   - Dissenyar diagrames **Entitat-Relació (ER)** complexes amb:  
     - Entitats, atributs, relacions i cardinalitats.  
     - Identificació de claus primàries/foranes.  
   - Transformar models conceptuals (ER) a models lògics (**relacionals**).  

###**SQL**  
   - Crear i gestionar bases de dades amb **sentències DDL** (CREATE, ALTER, DROP).  
   - Implementar **restriccions** (PK, FK, CHECK) i regles de propagació (CASCADE).  
   - Escriure consultes complexes (**JOIN, GROUP BY, subconsultes**) per a informes clínics.
   - Treballar amb models jeràrquics. 

###**Eines i Pràctiques Col·laboratives**  
   - Utilitzar entorns com **Oracle SQL Developer** per a implementar i validar el model.  
   - Treballar en equip per a resoldre conflictes de disseny 

### **Documentació i Avaluació**  
   - Generar **jocs de proves** amb dades reals per validar requeriments.  
   - Documentar decisions de disseny.  

## Components del Projecte
**Disseny Conceptual**: Inclou el diagrama Entitat-Relació (ER) que descriu les entitats principals (Pacient, Treballador, Visites, Malaltia, Protocol, Cicle, Medicació) i les seves interrelacions.
**Disseny Lògic**: Conté el model relacional amb les taules de la base de dades, les claus primàries i foranes, així com les restriccions referencials.
**Script SQL**: Inclou les sentències SQL per a la creació de taules, inserció de dades i consultes per validar el funcionament del sistema.
**Joc de Proves**: Proporciona consultes SQL per verificar que la base de dades satisfà els requeriments inicials.

## Requeriments
El sistema ha de permetre:
- Registrar i gestionar pacients, treballadors i visites.
- Assignar protocols i medicacions segons les necessitats dels pacients.
- Documentar cicles d'intervenció i esdeveniments clínics.
- Generar informes sobre l'activitat a la UCI.

## Entitats Principals
- **Pacient**: Emmagatzema informació dels pacients (ID, nom, cognom).
- **Treballador**: Conté dades del personal sanitari (ID, nom, cognom, rol).
- **Visites**: Registra les visites dels pacients a la UCI (data, hora, pes, edat, temps total).
- **Malaltia**: Llista les malalties associades als pacients (nom, indicador de presència).
- **Protocol**: Defineix els protocols mèdics seguits pels pacients (ritme d'aturada, codi de protocol).
- **Cicle**: Documenta els cicles d'intervenció (número de cicle, temps de cicle).
- **Medicació**: Detalla els medicaments utilitzats en els protocols (nom, dosi, quantitat fixa).
