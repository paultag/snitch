(import os [pymongo [Connection]])

(setv db (getattr (Connection
  (.get os.environ "SNITCH_MONGO_DB_HOST" "localhost")
  (int 27017)) "snitch"))
