# Datalogue
Datalogue is a simple data management plugin made for the Godot Engine.

![Main UI](/screenshots/main_ui.png)

## Why using Datalogue?
When storing static data, there is multiple approaches possible. One can use a SQL database, like SQLite, use text files like JSON or use structure in the source code like a Dictionary.
All this solutions come with advantages and drawbacks, Datalogue tries to keep the firsts while avoiding the lasts.

Here's why you would want to use Datalogue:
  - Flexibility of the data structure, you don't need to define what the data should look like
  - Query language, you can quiclky and easily retrieve the data you are looking for
  - GDScript API, you can interact with your data directly from your scripts
  - Integrated UI, you can manage your data without leaving the Godot Editor


## When to use Datalogue?
Datalogue can be use in all kind of games and projects. Use it when you want to store static data.

Datalogue databases are not meant to be modified once the project is exported. It however offers the possibility to manipulate data in memory, which can be saved and loaded to/from a user folder.


## How to use Datalogue?
Datalogue can be installed by cloning this repository or from the Godot's AssetLib. You just need the files under `/addons/datalogue` to be copied into any Godot project and then you need to enable the plugin inside the project settings.

Quick start:
  1. The Datalogue UI is accessible by switching to the "Data" view at the top of the window
  2. Add a database by pressing the + button at the bottom of the first column
  3. Select the newly created database in the list
  4. Add an item by pressing the + button at the bottom of the middle column
  5. Select the newly created item
  6. Add some data using the + buttons on the side of the last column
  7. You can retrieve a database in your GDScript by using `Datalogue.get_database("database_id")`
  8. You can retrieve an item by using `database.get_item("item_id")`
  9. You can retrieve item data by using `item.get_classification("classification_id")`, `item.get_value("value_id")` or `item.get_text("text_id")`


# Documentation
Coming soon
