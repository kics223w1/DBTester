import Foundation
import JavaScriptCore
import NIO
import PostgresNIO
import PostgresClientKit

class DBTesterCore : ObservableObject {

    // A context for running JavaScript code
    private var jsContext: JSContext?

    init() {
        // Initialize the JavaScript context
        self.jsContext = JSContext()

        // Check for errors in JavaScript execution
        self.jsContext?.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JavaScript Error: \(exc)")
            }
        }
    }
    
    func connectDatabase() async {
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "localhost"
            configuration.database = "caohuy"
            configuration.user = "caohuy"
            configuration.credential = Credential.trust
            configuration.ssl = false
//            configuration.credential = Credential.cleartextPassword(password: String)

            let connection = try PostgresClientKit.Connection(configuration: configuration)
//            defer { connection.close() }
            print("huy voa ne")

            let text =  """
SELECT
    is_nullable, data_type, column_name
    FROM
    information_schema.columns
WHERE
table_name = 'employees';
"""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
              print("row: " , columns)
            }
        } catch {
            print(error) // better error handling goes here
        }
        
        
    }

    func runSample() {
        // JavaScript code to be executed
        let jsCode = """
        function greet(name) {
            return 'Hello, ' + name + '!';
        }
        greet('World');
        """

        // Evaluate the JavaScript code
        if let result = jsContext?.evaluateScript(jsCode) {
            print("JavaScript Result: \(result)")
        } else {
            print("Failed to execute JavaScript code.")
        }
    }
}
