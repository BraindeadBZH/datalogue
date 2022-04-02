API
===

| Datalogue offers multiple GDScript classes to access your data in scripts.
| Some of the offered functions can only be accessed while in tool mode (i.e.
  editor scripts).

Datalogue
---------

``Datalogue`` is the entry point to the API, it is an autoload singleton.

At runtime you can use:

* ``databases() -> Dictionary[string][DlDatabase]`` to retrieve all the
  databases as map using the id as key
* ``get_database(id: String) -> DlDatabase`` to retrieve the database with the
  given id or null if it does not exist

In tool mode you can use:

* ``validate_id(id: String) -> String`` to check if the given string can be
  used for as database id, if it can the returned string is empty otherwise it
  contains an error message
* ``update_database(modified_db: DlDatabase, old_id: String = "") -> void`` to
  save to disk a modification made to the given database, if you change the
  database id the old id should also given.
* ``copy_database(origin: DlDatabase, new_id: String) -> void`` to create a
  copy on disk of the given database with the given id
* ``delete_database(id: String) -> void`` to remove a database from disk

In tool mode you can also connect to the following signals:

* ``database_added()`` emitted when a database is inserted into the list
* ``database_updated(db: DlDatabase)`` emitted when a database has been
  modified in the list
* ``database_removed()`` emitted when a database is removed from the list
