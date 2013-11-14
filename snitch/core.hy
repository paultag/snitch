(import [pymongo [Connection]])

(setv db (getattr (Connection "localhost" 27017) "snitch"))
