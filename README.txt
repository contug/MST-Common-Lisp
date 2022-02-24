Constantin Brinza 857047 - Giacomo Contu 856672


MST Prim - Common Lisp


Interfaccia grafi


f: is-vertex (graph-id vertex-id)
Verifica se il vertice corrispondente si trova nella hash table *vertices*.


f: is-arc (graph-id vertex-id vertex-id1 &optional weight)
Verifica se l’arco corrispondente si trova nella hash table *arcs*.


f: arc-w (graph-id vertex-id vertex-id1)
Ritorna il peso dell’arco che collega due vertici del grafo.


f: inserisci-w (graph-id vertex-id vertex-id1 weight)
Inserisce un nuovo arco che collega due vertice del grafo nel caso in cui non sia già presente. Se l’arco tra i due vertici è già presente, aggiorna il peso.






Min-Heap


f: inserisci-vuoto (heap-id k v)
Inserisce un elemento nello heap nel caso in cui Heap-empty è Vero.


f: inserisci-h (heap-id k v)
Inserisce un elemento nello heap nel caso in cui Heap-not-empty è Vero.


f: ordina-heap (array index)
Simile alla “swim operation” in un min-heap. Confronta il parent dell’elemento (all’indice “index”) e li scambia se parent.key risulta maggiore di child.key.
Il processo è ripetuto finchè l’elemento si trova nella posizione “giusta” che rispetti la “Heap priority”.


f: scambia (array index index-parent parent element)
Funzione chiamata da “ordina-heap(array index)” per effettuare lo scambio tra due elementi nello heap.


f: check-array (array k v)
Controlla la presenza di una coppia chiave-valore in uno heap.


f: heapify (A i length)
Implementazione dell’algoritmo Heapify su un array A, con indice i e dimensione length.






MST Prim


f: graph-vertices-key (graph-id)
Dato graph-id, restituisce la lista vertex-key-rep-list i cui elementi sono: (vertex-id key)


f: graph-previous (graph-id)
Dato graph-id, restituisce la lista vertex-prev-rep-list i cui elementi sono:
(vertex-id vertex-previous)


f: restore (graph-id)
Sottofunzione di MST-Prim.
Libera le hash tables *previous*, *vertex-key*, *visited* e la priority queue per essere utilizzate in vista di un nuovo lancio dell’algoritmo MST-Prim.


f: extract1 (graph-id)
Sottofunzione di MST-Prim.
Chiama “heap-extract(Q)” per essere successivamente confrontato con i vertici “vicini”.


f: compare (graph-id vertex-id)
Sottofunzione di MST-Prim.
Esegue il confronto tra il peso dell’arco che collega il vertice preso in considerazione e la chiave di uno dei suoi “vertex-adjs”.


f: update-hash (graph-id u v weight)
Sottofunzione di MST-Prim.
Chiama “modify-key(heap-id new-key old-key value)” per aggiornare la chiave di un nodo dell’albero mst.
Inoltre cambia la “key” del nodo e il suo “previous” dentro le due hash tables rispettivamente *vertex-key* e *previous*.


f: fill-heap (graph-id)
Sottofunzione di MST-Prim.
Inizializza la “priority-queue” Q dopo aver settato tutte le “keys” dei vertici a “inf” e i “previous” a nil. 


f: set-key-previous (graph-id source)
Dato graph-id, per ogni suo vertice imposta nelle hash tables *vertex-key* e *previous* i valori:
Peso = MOST-POSITIVE-DOUBLE-FLOAT (0 nel caso del vertice source)
Previous = nil
Il formato dei dati inseriti nelle hash tables sarà:
Chiave = (graph-id vertex-id)
Valore = Peso (in *vertex-key*)
Valore = nil (in *previous*)


f: get-child-list (graph-id vertex-id)
Dato un vertice vertex-id, restituisce una lista di tutti i vertici figlio di vertex-id dopo averli ordinati


f: mst-tree (graph-id source child-list)
Dato un vertice source, inserisce secondo una lettura pre-order gli archi che compongono il MST già formato nella hash table *visited* (libera al momento dell’inserimento)


f: mst-arc-list (graph-id)
Dato graph-id, restituisce una lista degli archi che compongono il MST ricavandoli dai dati inseriti in *visited* dalla funzione “mst-tree”, con ordinamento pre-order