//
//  AddingClass.swift
//  DBTester
//
//  Created by Cao Huy on 26/7/24.
//

import Foundation

class AddingClass {
    
    func getTopAddingScriptAtSecondTime(models: [ColumnAttributeModel]) -> String {
        let jsObjects = models.map { model in
                    model.getJSObject()
        }
        
        // Flatten the array of JS objects into a single JavaScript array
        let jsArrayString = jsObjects.joined(separator: ",\n")
        
                // Create the final script string
                return
"""
class Assert {
    equal(current, expected) {
       if(current == expected) {
            return true;
       }

       throw new Error(`Expected ${expected} got ${current}`);
    }
}

class UnitTestHandler {
    models = [\(jsArrayString)];
}

const assert = new Assert();
const unitTestHandler = new UnitTestHandler();

function it(unitTestName, callBack) {
    try {
        callBack()
    } catch(e) {
        console.log(`Error at: ${unitTestName} with message: ${e.message}`)
    }
}

function getColumnAttribute(tableName, columnName, columnKey) {
    const index = unitTestHandler.models.findIndex((model) => model.tableName === tableName && model.columnName === columnName)
    if(index === -1) {
        return undefined;
    }

    const keys = unitTestHandler.models[index].keys;
    const results = unitTestHandler.models[index].results;

    const indexKey = keys.findIndex((key) => key === columnKey);

    return indexKey === -1 ? undefined : results[indexKey];
}
"""
    }
    
    func getTopAddingScriptAtFirstTime() -> String {
        return
"""
class Assert {
    equal(current, expected) {
       
    }
}

class UnitTestHandler {
    infos = []

    getSQLCommands() {
        return this.infos.flatMap((info) => {
            return [{
                commands: info.arr.flatMap((key) => {
                    return [`SELECT ${key} FROM information_schema.columns WHERE table_name = '${info.tableName}' AND column_name = '${info.columnName}'`]
                }),
                tableName: info.tableName,
                columnName : info.columnName,
                keys: info.arr
            }]
        })
    }
}

const assert = new Assert();
const unitTestHandler = new UnitTestHandler();

function it(unitTestName, callBack) {
    callBack();
}

function getColumnAttribute(tableName, columnName, key) {
    const index = unitTestHandler.infos.findIndex((info) => {
        return info.tableName === tableName && info.columnName === columnName;
    })

    if(index === -1) {
        const obj = {
            arr: [key],
            tableName,
            columnName,
        }
        unitTestHandler.infos.push(obj);
    } else {
        unitTestHandler.infos[index].arr.push(key);
    }

    return undefined
}
"""
    }
    
    func getBottomAddingScriptAtFirstTime() -> String {
        return
"""
function main() {
    return unitTestHandler.getSQLCommands();
}

main();
"""
    }
}
