
const CATEGORY_TABLE = 'category';
const CATEGORY_COLUMN_ID = 'id';
const CATEGORY_COLUMN_TITLE = 'title';

/*
    +-------------------------+
    | category                |
    +-------------------------+
    | id: INTEGER PRIMARY KEY |
    +-------------------------+
    | title: TEXT NOT NULL    |
    +-------------------------+
 */

class Category {

  // FIELDS --------------------------------------------------------------------

  int id;
  String title;

  // CONSTRUCTORS --------------------------------------------------------------

  Category({this.id, this.title});

  Category.fromMap(Map<String, dynamic> map) {
    id = map[CATEGORY_COLUMN_ID];
    title = map[CATEGORY_COLUMN_TITLE];
  }

  // METHODS -------------------------------------------------------------------

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      CATEGORY_COLUMN_TITLE: title,
    };

    if (id != null) map[CATEGORY_COLUMN_ID] = id;

    return map;
  }
}