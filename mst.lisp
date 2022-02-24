;;Constantin Brinza 857047 - Giacomo Contu 856672

;; -*- Mode: Lisp -*-

(defparameter *vertices* (make-hash-table :test #' equal))

(defparameter *arcs* (make-hash-table :test #' equal))

(defparameter *graphs* (make-hash-table :test #' equal))

(defparameter *visited* (make-hash-table :test #' equal))

(defparameter *vertex-key* (make-hash-table :test #' equal))

(defparameter *previous* (make-hash-table :test #' equal))

(defparameter *heaps* (make-hash-table :test #' equal))



(defun is-graph (graph-id)
  (gethash graph-id *graphs*))

(defun new-graph (graph-id)
  (or (gethash graph-id *graphs*)
      (setf (gethash graph-id *graphs*) graph-id)))

(defun delete-graph (graph-id)
  (remhash graph-id *graphs*)
  (mapcar #'(lambda (x)
              (remhash x *vertices*))
          (graph-vertices graph-id))
  (mapcar #'(lambda (x)
              (remhash x *arcs*))
          (graph-arcs graph-id)))

(defun new-vertex (graph-id vertex-id)
  (cond ((is-graph graph-id)
         (setf (gethash (list 'vertex graph-id vertex-id) *vertices*)
               (list 'vertex graph-id vertex-id)))))

(defun graph-vertices (graph-id)
  (let ((vertex-rep-list ()))
    (maphash #'(lambda (key value)
                 (cond ((equal (second value) graph-id)
                        (push key vertex-rep-list))))
             *vertices*)
    vertex-rep-list))

(defun is-vertex (graph-id vertex-id)
  (gethash (list 'vertex graph-id vertex-id) *vertices*))

(defun is-arc (graph-id vertex-id vertex-id1 &optional weight)
  (cond 
   ((eql weight nil)
    (gethash (list 'arc graph-id vertex-id vertex-id1 1) *arcs*))
   (t 
    (gethash (list 'arc graph-id vertex-id vertex-id1 weight)
             *arcs*))))

(defun arc-w (graph-id vertex-id vertex-id1)
  (let ((w 0))
    (maphash #'(lambda (key value)
                 (cond 
                  ((or 
                    (and      
                     (equal (second value) graph-id)
                     (equal (third value) vertex-id)
                     (equal (fourth value) vertex-id1)
                     (setf w (+ w (fifth key))))
                    (and      
                     (equal (second value) graph-id)
                     (equal (third value) vertex-id1)
                     (equal (fourth value) vertex-id)
                     (setf w (+ w (fifth key))))))))
             *arcs*)
    w))

(defun new-arc (graph-id vertex-id vertex-id1 &optional weight)
  (if (and
       (is-vertex graph-id vertex-id)
       (is-vertex graph-id vertex-id1))
      (if (eql weight nil)
          (inserisci-w graph-id vertex-id vertex-id1 1)
        (inserisci-w graph-id vertex-id vertex-id1 weight))
    nil))

(defun inserisci-w (graph-id vertex-id vertex-id1 weight)
  (cond 
   ((or (is-arc graph-id vertex-id vertex-id1 weight)
        (is-arc graph-id vertex-id1 vertex-id weight))
    nil)

   ((is-arc graph-id vertex-id vertex-id1
            (arc-w graph-id vertex-id vertex-id1))
    (and 
     (remhash (list 'arc graph-id vertex-id vertex-id1
                    (arc-w graph-id vertex-id vertex-id1)) *arcs*)
     (setf (gethash (list 'arc graph-id vertex-id vertex-id1 weight)
                    *arcs*)
           (list 'arc graph-id vertex-id vertex-id1 weight))))
   ((is-arc graph-id vertex-id1 vertex-id
            (arc-w graph-id vertex-id vertex-id1))
    (and 
     (remhash (list 'arc graph-id vertex-id1 vertex-id
                    (arc-w graph-id vertex-id vertex-id1)) *arcs*)
     (setf (gethash (list 'arc graph-id vertex-id vertex-id1 weight)
                    *arcs*)
           (list 'arc graph-id vertex-id vertex-id1 weight))))

   (t (setf (gethash (list 'arc graph-id vertex-id vertex-id1 weight)
                     *arcs*)
            (list 'arc graph-id vertex-id vertex-id1 weight)))))          

(defun graph-arcs (graph-id)
  (let ((arc-rep-list ()))
    (maphash #'(lambda (key value)
                 (cond ((eql (second value) graph-id)
                        (push key arc-rep-list))))
             *arcs*)
    arc-rep-list))
         
(defun graph-vertex-neighbors (graph-id vertex-id)
  (let ((arc-rep-list ()))
    (mapcar #'(lambda (value)
                (cond ((and
                        (eql (second value) graph-id)
                        (eql (fourth value) vertex-id))
                       (push (list 'arc graph-id vertex-id
                                   (third value)
                                   (fifth value)) arc-rep-list))
                      ((and
                        (eql (second value) graph-id)
                        (eql (third value) vertex-id))
                       (push value arc-rep-list))))
            (graph-arcs graph-id))         
    arc-rep-list))
 
(defun graph-vertex-adjacent (graph-id vertex-id)
  (let ((vertex-rep-list ()))
    (mapcar #'(lambda (value)
                (push (list 'vertex graph-id (fourth value))
                      vertex-rep-list))
            (graph-vertex-neighbors graph-id vertex-id))         
    vertex-rep-list))
  
(defun graph-print (graph-id)
  (mapcar (function print) (graph-vertices graph-id))
  (mapcar (function print) (graph-arcs graph-id))
  (print "Fine"))







(defun new-heap (heap-id &optional (capacity 42))
  (or (gethash heap-id *heaps*)
      (setf (gethash heap-id *heaps*)
            (list 'heap heap-id 0 (make-array capacity)))))

(defun heap-id (heap-id)
  (second (gethash heap-id *heaps*)))

(defun heap-size (heap-id)
  (third (gethash heap-id *heaps*)))

(defun heap-actual-heap (heap-id)
  (fourth (gethash heap-id *heaps*)))

(defun heap-delete (heap-id)
  (remhash heap-id *heaps*))

(defun heap-empty (heap-id)
  (if (gethash heap-id *heaps*)
      (= (heap-size heap-id)
         0)
    (error "Heap non trovato")))

(defun heap-not-empty (heap-id)
  (if (gethash heap-id *heaps*)
      (> (heap-size heap-id)
         0)
    (error "Heap non trovato")))

(defun heap-head (heap-id)
  (if (gethash heap-id *heaps*)
      (aref (heap-actual-heap heap-id) 0)
    (error "Heap non trovato")))

(defun heap-insert (heap-id k v)
  (if (eql nil (gethash heap-id *heaps*))
      (error "Heap non trovato"))
  (cond ((check-array (heap-actual-heap heap-id)
                      k v)
         (error "Coppia già presente")))
  (if (heap-empty heap-id)
      (inserisci-vuoto heap-id k v)
    (inserisci-h heap-id k v)))

(defun inserisci-vuoto (heap-id k v)
  (setf (third (gethash heap-id *heaps*))
        (+ 1 (heap-size heap-id)))
  (setf (aref (heap-actual-heap heap-id) 0) (list k v))
  t)

(defun inserisci-h (heap-id k v)
  (setf (aref (heap-actual-heap heap-id) (heap-size heap-id))
        (list k v))
  (setf (third (gethash heap-id *heaps*))
        (+ 1 (heap-size heap-id)))
  (ordina-heap (heap-actual-heap heap-id) (1- (heap-size heap-id)))
  t)

(defun ordina-heap (array index)
  (cond ((> index 0)
         (let ((element (aref array index))
               (parent (if (evenp index)
                           (aref array
                                 (1- (floor index 2)))
                         (aref array
                               (floor index 2))))
               (index-parent (if (evenp index)
                                 (1- (floor index 2))
                               (floor index 2))))
           (if
               (< (first element) (first parent))
               (scambia array index index-parent parent element)
             (aref array index))))
        ((< index 1) (aref array index))))

(defun scambia (array index index-parent parent element)
  (setf (aref array index) parent)
  (setf (aref array index-parent) element)
  (ordina-heap array index-parent))

(defun check-array (array k v)
  (let ((index (position (list k v) array
                         :test #'equal)))
    (if (not (eql index nil))
        t)))
  
(defun heap-extract (heap-id)
  (let ((rad (heap-head heap-id))
        (array (heap-actual-heap heap-id))
        (last (aref (heap-actual-heap heap-id)
                    (1- (heap-size heap-id)))))
    (setf (aref array 0) last)
    (setf (aref array (1- (heap-size heap-id)))
          nil)
    (setf (third (gethash heap-id *heaps*))
          (1- (heap-size heap-id)))
    (heapify array 0 (1- (heap-size heap-id)))
    rad))

(defun heapify (A i length)
  (let ((left (1+ (* 2 i)))
	(right (+ (* 2 i) 2))
	(rad (first (aref A i))))
    (if (and (<= left length)
	     (<= right length))
        (cond ((and (<= (first (aref A left)) (first (aref A right)))
		    (< (first (aref A left)) rad))
	       (let ((appoggio (aref A i)))
		 (setf (aref A i) (aref A left))
		 (setf (aref A left) appoggio)
		 (heapify A left length)))
	      ((and (< (first (aref A right)) (first (aref A left)))
		    (< (first (aref A right)) rad))
	       (let ((appoggio (aref A i)))
		 (setf (aref A i) (aref A right))
		 (setf (aref A right) appoggio)
		 (heapify A right length)))))
    (if (and (<= left length)
	     (> right length))
	(cond ((< (first (aref A left)) rad)
	       (let ((appoggio (aref A i)))
		 (setf (aref A i) (aref A left))
		 (setf (aref A left) appoggio)
		 (heapify A left length)))))))

(defun heap-print (heap-id)
  (gethash heap-id *heaps*))









(defun graph-vertices-key (graph-id)
  (let ((vertex-key-rep-list ()))
    (maphash #'(lambda (key value)
                 (cond ((equal (first key) graph-id)
                        (push (list (second key) 
                                    value) vertex-key-rep-list))))
             *vertex-key*)
    vertex-key-rep-list))

(defun graph-previous (graph-id)
  (let ((vertex-prev-rep-list ()))
    (maphash #'(lambda (key value)
                 (cond ((equal (first key) graph-id)
                        (push (list (second key) 
                                    value) vertex-prev-rep-list))))
             *previous*)
    vertex-prev-rep-list))

(defun mst-prim (graph-id source)
  (if (eql (is-graph graph-id) nil)
      (error "Grafo non trovato"))
  (if (eql (is-vertex graph-id source) nil)
      (error "Radice non trovata"))
  (restore graph-id)
  (set-key-previous graph-id source)
  (fill-heap graph-id)
  (extract1 graph-id)
  (maphash #'(lambda (key value)
               (remhash key *visited*)) *visited*))

(defun restore (graph-id)
  (heap-delete 'xz)
  (maphash #'(lambda (key value)
               (remhash key *vertex-key*)) *vertex-key*)
  (maphash #'(lambda (key value)
               (remhash key *previous*)) *previous*)) 
           
(defun extract1 (graph-id)
  (if (heap-empty 'xz)
      nil
    (let ((u (heap-extract 'xz)))
      (setf (gethash (second u) *visited*)
            (second u))
      (compare graph-id u))))

(defun compare (graph-id vertex-id)
  (let ((array (graph-vertex-adjacent graph-id (second vertex-id))))
    (mapcar #'(lambda (x)
                (let ((weight-w
                       (arc-w graph-id (second vertex-id) (third x))))
                  (if (and
                       (eql nil (gethash (third x) *visited*))
                       (< weight-w (gethash (list graph-id (third x))
                                            *vertex-key*)))
                      (update-hash graph-id (second vertex-id)
                                   (third x) weight-w))))
            array))
  (extract1 graph-id))
                      
(defun update-hash (graph-id u v weight)
  (heap-modify-key 'xz weight 
                   (gethash (list graph-id v) *vertex-key*) v)
  (setf (gethash (list graph-id v) 
                 *vertex-key*) weight)
  (setf (gethash (list graph-id v)
                 *previous*) u))
  
(defun fill-heap (graph-id)
  (let ((array (graph-vertices-key graph-id)))
    (new-heap 'xz (length array))
    (mapcar #'(lambda (x)
                (heap-insert 'xz (second x) (first x))) array)))        
        
(defun set-key-previous (graph-id source)
  (mapcar #'(lambda (x)
              (setf (gethash (list graph-id (third x)) *vertex-key*)
                    MOST-POSITIVE-DOUBLE-FLOAT))
          (graph-vertices graph-id))
  (mapcar #'(lambda (x)
              (setf (gethash (list graph-id (third x)) *previous*)
                    nil))
          (graph-vertices graph-id))
  (setf (gethash (list graph-id  source) *vertex-key*)
	0))              

(defun heap-modify-key (heap-id new-key old-key v)
  (let ((array (heap-actual-heap heap-id))
        (index (position (list old-key v) (heap-actual-heap heap-id)
                         :test #'equal)))
    (setf (aref array index) (list -11 v))
    (ordina-heap array index)
    (heap-extract heap-id)
    (heap-insert heap-id new-key v)))

(defun mst-vertex-key (graph-id vertex-id)
  (gethash (list graph-id vertex-id) *vertex-key*))

(defun mst-previous (graph-id vertex-id)
  (gethash (list graph-id vertex-id) *previous*))

(defun get-child-list (graph-id vertex-id)
  (let ((child-list-k ())
	(child-list-p ())
	(tmp ()))
    (maphash #'(lambda (key value)
		 (cond ((equal value vertex-id)
			(push (list (second key)
				    (mst-vertex-key
				     graph-id (second
					       key)))
			      child-list-k))))
             *previous*)
    (sort child-list-k #'< :key #'second)
    (mapcar #'(lambda (x)
		(push (list (first x) (mst-previous graph-id
						    (first x)))
		      tmp))
            child-list-k)
    (mapcar #'(lambda (x) (push x child-list-p)) tmp)
    child-list-p))

(defun mst-tree (graph-id source child-list)
  (cond ((not (null child-list))
	 (push (list 'arc graph-id source
		     (first (car child-list))
		     (mst-vertex-key graph-id (first (car
						      child-list))))
	       (gethash graph-id *visited*))
	 (mst-tree graph-id (first (car child-list))
		   (get-child-list graph-id (first (car child-list))))
	 (mst-tree graph-id source (cdr child-list)))))

(defun mst-arc-list (graph-id)
  (let ((preorder-mst ()))
    (mapcar #'(lambda (x) (push x preorder-mst))
	    (gethash graph-id *visited*))
    preorder-mst))

(defun mst-get (graph-id source)
  (if (not (gethash (list graph-id source) *vertex-key*))
      (error "Albero non trovato"))
  (setf (gethash graph-id *visited*) (list))
  (mst-tree graph-id source (get-child-list graph-id source))
  (mst-arc-list graph-id))


;; end of file -- mst.lisp --