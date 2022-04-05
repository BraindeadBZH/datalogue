===
API
===

| Datalogue offers multiple GDScript classes to access your data in scripts.
| Some of the offered functions can only be accessed while in tool mode (i.e.
  editor scripts).

Datalogue
=========

``Datalogue`` is the entry point to the API, it is an autoload singleton.

At runtime you can use:

* ``databases() -> Dictionary[string][DlDatabase]`` to retrieve all the
  databases as map using the id as key
* ``get_database(id: String) -> DlDatabase`` to retrieve the database with the
  given id or null if it does not exist

In tool mode you can use:

* ``validate_id(id: String) -> String`` to check if the given string can be
  used for as a database id, if it can, the returned string is empty, otherwise
  it contains an error message
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

DlDatabase
==========

``DlDatabase`` represents 1 database designed by its id and containing items.

At runtime you can use:

* ``id() -> String`` to retrieve the database's id
* ``count() -> int`` to retrieve the number of items in the database
* ``statistics() -> Dictionary`` to retrieve some statistics about this
  database (more details below)
* ``items() -> Dictionary`` to retrieve all the items in the form
  ``[<item id>: <item>]``
* ``item_exists(id: String) -> bool`` to check if an item is in the database
* ``get_item(id: String) -> DlItem`` to retrieve the item with the given id or
  null if it does not exist

In tool mode you can use:

* ``set_id(new_id: String) -> void`` to change the database's id
* ``duplicate(new_id: String = "") -> DlDatabase`` to create a copy of this
  database with the given ``new_id``. If ``new_id`` is empty then the copy has
  the same id as this database. Note: the copy is not written to disk, contrary
  to the ``Datalogue.copy_database function``
* ``validate_item_id(id: String) -> String`` to check if the given string can
  be used for as an item id, if it can, the returned string is empty, otherwise
  it contains an error message
* ``add_item(item: DlItem) -> void`` to add the given item to the database.
  Note: the change is not written to disk until you call
  ``Datalogue.update_database``
* ``copy_item(origin: DlItem, new_id: String) -> void`` to create a copy of the
  given item with the given ``new_id``. Note: the change is not written to disk
  until you call ``Datalogue.update_database``
* ``update_item(modified_item: DlItem, old_id: String = "") -> void`` to update
  the given ``modified_item``. If you have changed the item id, the ``old_id``
  should be also given. Note: the change is not written to disk until you call
  ``Datalogue.update_database``
* ``remove_item(id: String) -> void`` to remove the item with the given id from
  the database. Note: the change is not written to disk until you call
  ``Datalogue.update_database``

In tool mode you can also connect to the following signals:

* ``changed()`` emitted when the database has changed

The statistics are given as a Dictionary with the following structure:

* ``["items"]`` contains the total number of item in the database
* ``["classes"]["<classif id>"]`` contains the number of items with the given
  classification
* ``["classes_values"]["<classif id>"]["<value>"]`` contains the number of
  items with the given classification value
* ``["values"]["<value id>"]`` contains the number of items with the given
  value
* ``["values_min"]["<value id>"]`` contains the minimum of the given value
* ``["values_max"]["<value id>"]`` contains the maximum of the given value
* ``["texts"]["<text id>"]`` contains the number of items with the given text
