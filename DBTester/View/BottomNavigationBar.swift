import SwiftUI

struct BottomNavigationBar: View {
    var body: some View {
        VStack {
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.black)
            
            HStack {

            }
            .frame(height: 20, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 20)
        .background(Color(red: 55/255, green: 55/255, blue: 53/255))
    }
}

#Preview {
    BottomNavigationBar()
}
