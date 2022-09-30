//
//  MyStreamApp.swift
//  MyStream
//
//  Created by stefano.spinelli on 20/09/22.
//

import SwiftUI
import FirebaseCore
import Firebase



class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    static var orientationLock = UIInterfaceOrientationMask.all
    
    //Firebase Config
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        
        
        return true
    }
    
    

    
    func application(_  application : UIApplication, supportedInterfaceOrientationsFor window : UIWindow?) -> UIInterfaceOrientationMask{
        
        return AppDelegate.orientationLock
        
    }
    
    
}

@main
struct MyStreamApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //this is used to check the login session state
    @StateObject var sessionService = SessionServiceImpl()
    
    init() {
        modifyTabBarColor()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                TabView {
                    RootView()
                        .tabItem {
                            Image(systemName: "film")
                            Text("MOVIES")
                        }
                    SeriesPageMainView()
                        .tabItem {
                            Image(systemName: "sparkles.tv")
                            Text("TV")
                        }
                    
                    
                    // Tab ar items change according to the session login state
                    switch sessionService.state{
                    case .loggedIn:
                        //the environmentObject inject the data to the childView
                        HomeView()
                            .environmentObject(sessionService)
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                        
                    case .loggedOut:
                        LoginView()
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Log In")
                            }
                    }
                    
                    
                }  .foregroundColor(.black)
                    .accentColor(.orange)
            }.onAppear{
                AppDelegate.orientationLock = .portrait }
        }
    }
}



