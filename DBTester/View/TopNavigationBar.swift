import SwiftUI

struct TopNavigationBar: View {

    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var projectManagerService: ProjectManagerService

    @State private var isPopoverShowing = false
    @State private var isPopoverConnectionVisible = false

    

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Local | PostgreSQL")
                .padding(.leading, 8)
                .frame(minWidth: 300, minHeight: 25, alignment: .leading)
                .background(Color(red: 0.0, green: 0.5, blue: 0.0))
                .cornerRadius(4)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .popover(isPresented: self.$isPopoverConnectionVisible, arrowEdge: .bottom) {
                    PopoverConnection(isPopoverVisible: self.$isPopoverConnectionVisible)
                }
                .onTapGesture {
                    self.isPopoverConnectionVisible.toggle()
                }
            
            
            HStack {
                Button {
                    self.isPopoverShowing.toggle()
                } label: {
                    Text(projectManagerService.selectedProjectModel.name)
                    
                    Image(systemName: "chevron.down")
                        .resizable() // Make the image resizable
                        .frame(width: 8, height: 6)
                }
                .frame(minHeight: 35)
                .popover(isPresented: self.$isPopoverShowing, arrowEdge: .bottom) {
                    PopoverProject(isPopoverShowing: self.$isPopoverShowing)
                }
            }
            
           
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(height: 40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.black),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .onChange(of: alertManager.isOn) {
            if !alertManager.text.isEmpty && alertManager.fromWho == "TopNavigationBar" {
                projectManagerService.addNewProject(name: alertManager.text)
                alertManager.reset()
            }
        }
    }
}

// Preview
#Preview {
    TopNavigationBar()
}
