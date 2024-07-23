import SwiftUI

struct ConnectionForm: View {
    @Binding var selectedDatabase: Database
    
    @State var isSupported: Bool
    @State private var viewModel: ConnectionFormViewModel
    
    @State private var message: String = ""
    
    private let connectionFormController = ConnectionFormController()
    
    init(selectedDatabase: Binding<Database>) {
        self._selectedDatabase = selectedDatabase
        self.isSupported = true
        
        // Initialize viewModel with a placeholder
        let initialPlaceholders = connectionFormController.getPlaceholderObject(database: selectedDatabase.wrappedValue)
        _viewModel = State(initialValue: ConnectionFormViewModel(placeholders: initialPlaceholders))
    }
    
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Spacer()
                Text(isSupported ? "\(selectedDatabase.friendlyName) Connection" : "\(selectedDatabase.friendlyName) will be added in next releases")
                    .font(.headline)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            Form {
                Section() {
                    TextField("Name", text: $viewModel.name)
                        .disabled(!isSupported)
                    
                    TextField("Host", text: $viewModel.host)
                        .disabled(!isSupported)
                    
                    TextField("Port", text: $viewModel.port)
                        .disabled(!isSupported)
                    
                    TextField("Username", text: $viewModel.username)
                        .disabled(!isSupported)
                    
                    SecureField("Password", text: $viewModel.password)
                        .disabled(!isSupported)
                    
                    TextField("Database", text: $viewModel.database)
                        .disabled(!isSupported)
                }

                HStack(spacing: 4) {
                    Button(action: {
                        viewModel.addAndSaveConnection(selectedDatabase: selectedDatabase)
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .disabled(!isSupported)
                    .padding()
                    
                    Button(action: {
                        Task {
                            let result = await viewModel.testConnection(selectedDatabase: selectedDatabase)
                            DispatchQueue.main.async {
                                message = result == "OK" ? "Connect succeed" : result
                            }
                        }
                    }) {
                        Text("Test")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .disabled(!isSupported)
                    .padding()
                    
                    Button(action: {
                        // Connect action
                    }) {
                        Text("Connect")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(!isSupported)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(message != "Connect succeed" ? Color.red : Color.green)
            }
            
            Spacer()
            
            
        }
        .padding()
        .frame(maxHeight: .infinity)
        .onChange(of: selectedDatabase) {
            let newPlaceholders = connectionFormController.getPlaceholderObject(database: selectedDatabase)
            let newIsSupported = selectedDatabase == .postgreSQL
            
            viewModel = ConnectionFormViewModel(placeholders: newPlaceholders)
            isSupported = newIsSupported
        }
    }
}

#Preview {
    ConnectionForm(selectedDatabase: .constant(.postgreSQL))
}
