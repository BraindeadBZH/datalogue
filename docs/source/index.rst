Datalogue's documentation
=========================

.. attention::
  This plugin is **not** compatible with Godot 3.
  It uses features that are only available to the incoming Godot 4.


.. image:: https://github.com/BraindeadBZH/datalogue/raw/master/screenshots/main_ui.png

|

Datalogue is a data management plugin for the Godot Engine.
It originates from my previous plugin, CardEngine, and the way cards are managed in it.
I took the card database concept, made it better and working with all kind of data.
The idea is to provide a database that can be queried like a SQL database but with the flexibility of a format like JSON.


Why using Datalogue?
--------------------

When storing static data, there is multiple approaches possible.
One can use a SQL database, like SQLite, use text files like JSON or use structure in the source code like a Dictionary.
All this solutions come with advantages and drawbacks, Datalogue tries to keep the firsts while avoiding the lasts.

Here's why you would want to use Datalogue:

* Flexibility of the data structure, you don't need to define what the data should look like
* Query language, you can quickly and easily retrieve the data you are looking for
* GDScript API, you can interact with your data directly from your scripts
* Integrated UI, you can manage your data without leaving the Godot Editor
* The database files are VCS friendly



When to use Datalogue?
----------------------

Datalogue can be use in all kind of games and projects.
Use it when you want to store static data.

Datalogue databases are not meant to be modified once the project is exported.
It however offers the possibility to manipulate data in memory, which can be saved and loaded to/from a user folder (not yet implemented).


How to use Datalogue?
---------------------

Datalogue can be installed by cloning this repository or from the Godot's AssetLib.
You just need the files under ``/addons/datalogue`` to be copied into any Godot project and then you need to enable the plugin inside the project settings.

Quick start:

#. The Datalogue UI is accessible by switching to the "Data" view at the top of the window
#. Add a database by pressing the + button at the bottom of the first column
#. Select the newly created database in the list
#. Add an item by pressing the + button at the bottom of the middle column
#. Select the newly created item
#. Add some data using the + buttons on the side of the last column
#. You can retrieve a database in your GDScript by using ``Datalogue.get_database("database_id")``
#. You can retrieve item data by using ``item.get_classification("classification_id")``, ``item.get_value("value_id")`` or ``item.get_text("text_id")``


Detailed usage
--------------

Go to :doc:`the usage page <usage>`.


Api reference
-------------

Go to :doc:`the API reference page <api>`.
