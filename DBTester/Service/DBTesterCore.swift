import Foundation
import JavaScriptCore
import NIO
import PostgresNIO

class DBTesterCore {

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
        let config = PostgresClient.Configuration(
          host: "localhost",
          port: 5432,
          username: "caohuy",
          password: "caohuy",
          database: "caohuy",
          tls: .disable
        )
        
        let client = PostgresClient(configuration: config)
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { taskGroup in
                taskGroup.addTask {
                    await client.run() // !important
                }
                
                let rows = try await client.query("""
                    SELECT * FROM "user"
                    """)

//                for try await row in rows {
//                    print("huy ne \(row)")
//                }
                
                for try await (id, name) in rows.decode((String, String).self) {
                    print("huy ne \(id) \(name)")
                }
                
                
            }
        }catch {
            print("error ne \(error)")
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
