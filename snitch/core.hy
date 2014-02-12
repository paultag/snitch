(import [pymongo [Connection]])

(setv db (getattr (Connection "localhost" (int 27017)) "snitch"))
