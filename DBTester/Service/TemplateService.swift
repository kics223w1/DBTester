//
//  TemplateService.swift
//  DBTester
//
//  Created by Cao Huy on 25/7/24.
//

import Foundation

class TemplateService {
    
    static let shared = TemplateService()
    
    func getDefaultForFileModel(fileName :String) -> String {
        return fileName.hasSuffix(".js") ? self.getDefaultUnitTest() : self.getDefaultSQLCommand()
    }
    
    func getDefaultSQLCommand() -> String {
        return ""
    }
    
    func getDefaultUnitTest() -> String {
        return
"""
const tableName = "employees";

it("Test Column employee_id" , async () => {
    const columnName = "employee_id";

    const att1 = getColumnAttribute(tableName, columnName, "is_nullable");
    const att2 = getColumnAttribute(tableName, columnName, "data_type");

    assert.equal(att1, "NO");
    assert.equal(att2, "numeric");
})

it("Test Column first_name" , async () => {
    const columnName = "first_name";

    const att1 = getColumnAttribute(tableName, columnName, "is_nullable");
    const att2 = getColumnAttribute(tableName, columnName, "data_type");
    const att3 = getColumnAttribute(tableName, columnName, "character_maximum_length");

    assert.equal(att1, "NO");
    assert.equal(att2, "character varying");
    assert.equal(att3, 1000);
})


// function getColumnAttribute(tableName , columnName, key) {
    // This function execute the below command to get the
    // column attribute

    // const query = SELECT `${key}` FROM information_schema.columns
    // WHERE table_name = `${tableName}` AND column_name = `${columnName}`;
    // return db.query(query)
// }
"""
    }
    
}
