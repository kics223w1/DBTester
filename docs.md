### Function Overview
Below are examples of our core functions within the DBTester project. These functions illustrate how DBTester interacts with databases and handles unit testing.

### `getColumnAttribute`
```js
function getColumnAttribute(tableName, columnName, columnKey) {
    // We execute this SQL command to retrieve the value
    const command = `SELECT ${columnKey} FROM information_schema.columns WHERE table_name = '${tableName}' AND column_name = '${columnName}'`

    return db.query(command)
}
```

### `getConstraintObject`
```js
function getConstraintObject(constraintName) {
    // We execute this SQL command to retrieve the value
// SELECT
//     conname AS constraint_name,
//     conrelid::regclass AS table_name,
//     a.attname AS column_name,
//     confrelid::regclass AS foreign_table_name,
//     af.attname AS foreign_column_name
// FROM
//     pg_constraint
// JOIN
//     pg_attribute AS a ON a.attnum = ANY(conkey) AND a.attrelid = conrelid
// JOIN
//     pg_attribute AS af ON af.attnum = ANY(confkey) AND af.attrelid = confrelid
// WHERE
//     contype = 'f' 
// AND 
// 	conname = '${constraintName}'

    return {
        tableName,
        columnName,
        foreignTableName,
        foreginColumnName
    }
}
```