Usage
=====

Datalogue is designed to be straightforward to use.
So this should be a short but important read.


Installation
------------

There is two way to install:

* Using the Godot's AssetLib:
  * Search for "Datalogue" directly from the Godot Editor AssetLib tool
  * Press "Download"
* From Github:
  * Go to the repository: https://github.com/BraindeadBZH/datalogue
  * Download the code as an archive
  * Decompress the archive
  * Copy the addons folder to your project

In both case, you need to enable the plugin in your project's settings, in the "Plugins" tab.


Using the UI
------------

.. image:: https://github.com/BraindeadBZH/datalogue/raw/master/screenshots/main_ui.png

|

The UI is split into 3 mains sections displayed in columns:

* The first column is to manage your databases
* The second column is to manage your database's items
* The third column is to manage your item's data, it is split into 3 sub-sections, displayed in rows:
  * The first row is to manage classifications for your item
  * The second row is to manage numerical values for your item
  * The third row is to manage textual values for your items

All the sections work on the same model:

* A list which display the content:
  * A single click to select an object from the list
  * A double click to edit the selected object
* Three Buttons to manage the content:
  * The first button is to create a new object
  * The second button is to duplicate an object
  * The third button is to delete an object

(Note: be careful all modifications are definitive, there is no undo/redo)

In addition you can press the button at the top-right of the "Items" section to filter the displayed items.


Using the API
-------------

Accessing the data in your game is meant to be done using GDScript.
The main entry point is a Autoload singleton `Datalogue`.
For a detailed API reference: go to :doc:`the API reference page <api>`.
