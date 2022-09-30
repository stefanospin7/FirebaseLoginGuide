//
//  LoginView.swift
//  MyStream
//
//  Created by stefano.spinelli on 26/09/22.
//


import SwiftUI


//This view contains the logged in info about the user

struct HomeView: View {
    
    
    //this kind of object let us passing data from a parent to a child view
    //Keep in mind that you need it in the preview too if you don't want the preview to crash
    
    @EnvironmentObject var service: SessionServiceImpl
    
    var body: some View {
            VStack(alignment: .leading,
                   spacing: 16) {
                
//                VStack(alignment: .leading,
//                       spacing: 16) {
//                    Text("First Name: \(service.userDetails?.firstName ?? "N/A")")
//                    Text("Last Name: \(service.userDetails?.lastName ?? "N/A")")
//                    Text("Occupation: \(service.userDetails?.occupation ?? "N/A")")
//                    Text("Gender: \(service.userDetails?.gender ?? "N/A")")
//                }
                    
                    ButtonView(title: "Logout",background: .orange,foreground: .black) {
                        //logout logic
                        service.logout()
                    }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Main ContentView")        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(SessionServiceImpl())
        }
    }
}
