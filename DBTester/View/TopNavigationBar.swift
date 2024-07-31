import SwiftUI

struct TopNavigationBar: View {
    
    @State private var isPopoverShowing = false
    @State private var isPopoverConnectionVisible = false
    @State private var isHoveringButton = false
    @State private var connectionTitle : String = ""
    
    @Binding var mainPanelTab : MainPanelTab

    @EnvironmentObject var projectManagerService: ProjectManagerService
    @EnvironmentObject var connectionService: ConnectionService
    @EnvironmentObject var environmentString: EnvironmentString

    private func isConnectionOK() -> Bool {
        return connectionTitle.hasPrefix("Error!") || connectionTitle.hasPrefix("Tap to") ? false : true
    }
    
    private func updateConnectionTitle() async {
        connectionTitle = await connectionService.getSelectedTitle()
    }
    
    private func runSelectedTest() {
        
    }
    
    private func runAllTests() {
        mainPanelTab = .consoleLog
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("\(projectManagerService.selectedProjectModel.name) | \(connectionTitle)")
                    .padding(.leading, 8)
                    .frame(width: 400, height: 25, alignment: .leading)
                    .background(isConnectionOK() ? Color(red: 0.0, green: 0.5, blue: 0.0) : Color(red: 0.5, green: 0.1, blue: 0.0))
                    .cornerRadius(4)
                    .popover(isPresented: self.$isPopoverConnectionVisible, arrowEdge: .bottom) {
                        PopoverConnection(isPopoverVisible: self.$isPopoverConnectionVisible)
                    }
                    .onTapGesture {
                        self.isPopoverConnectionVisible.toggle()
                    }
                    .buttonStyle(BorderedButtonStyle())

                Button(action: {
                        runAllTests()
                }) {
                    Image(systemName: "play.fill")
                }
                .frame(height: 35)
                
                Text("FREE")
                    .bold()
                    .frame(width: 40, height: 25)
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
                    .background(Color.yellow)
                    .foregroundStyle(.black)
                    .cornerRadius(4)
            }
            .frame(height: 30, alignment: .center)
            .offset(y: 8)
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.black)
                .offset(y: 6)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 35)
        .background(Color(red: 55/255, green: 55/255, blue: 53/255))
        .onAppear {
            Task {
                await updateConnectionTitle()
            }
        }
        .onChange(of: connectionService.connections) {
            Task {
                await updateConnectionTitle()
            }
        }
    }
}

// Preview
#Preview {
    TopNavigationBar(mainPanelTab: .constant(.unitTest))
}
