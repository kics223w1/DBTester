import SwiftUI

struct TopNavigationBar: View {

    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var projectManagerService: ProjectManagerService

    @State private var isPopoverShowing = false
    @State private var isPopoverConnectionVisible = false

    @State private var isHoveringButton = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("Local | PostgreSQL")
                    .padding(.leading, 8)
                    .frame(width: 350, height: 25, alignment: .leading)
                    .background(Color(red: 0.0, green: 0.5, blue: 0.0))
                    .cornerRadius(4)
                    .popover(isPresented: self.$isPopoverConnectionVisible, arrowEdge: .bottom) {
                        PopoverConnection(isPopoverVisible: self.$isPopoverConnectionVisible)
                    }
                    .onTapGesture {
                        self.isPopoverConnectionVisible.toggle()
                    }
                
                Button(action: {
                    // Add your button action here
                }) {
                    Image(systemName: "cylinder.split.1x2")
                }
                .buttonStyle(BorderedButtonStyle())

                Button(action: {
                    // Add your button action here
                }) {
                    Image(systemName: "play.fill")
                }
                .buttonStyle(BorderedButtonStyle())
                    
            }
            .frame(height: 30, alignment: .center)
            .offset(y: 8)
            .onChange(of: alertManager.isOn) {
                if !alertManager.text.isEmpty && alertManager.fromWho == "TopNavigationBar" {
                    projectManagerService.addNewProject(name: alertManager.text)
                    alertManager.reset()
                }
            }
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.black)
                .offset(y: 6)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 35)
        .background(Color(red: 55/255, green: 55/255, blue: 53/255))
    }
}

// Preview
#Preview {
    TopNavigationBar()
}
