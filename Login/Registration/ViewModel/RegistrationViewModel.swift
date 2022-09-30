//
//  LoginView.swift
//  MyStream
//
//  Created by stefano.spinelli on 26/09/22.
//


import Foundation
import Combine

//Monitoring registration state
enum RegistrationState {
    case successfullyRegistered
    case failed(error: Error)
    case na
}

//this protocol inject our data in the View
protocol RegistrationViewModel {
    func create()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var hasError: Bool { get }
    var newUser: RegistrationCredentials { get }
    init(service: RegistrationService)
}

//we create the class with our protocol implementation
//it needs to be observable so we can call it as @StateObject in our view

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    
    let service: RegistrationService
    @Published var state: RegistrationState = .na
    @Published var newUser = RegistrationCredentials(email: "",
                                                     password: "",
                                                     firstName: "",
                                                     lastName: "",
                                                     occupation: "",
                                                     gender: .male)
    @Published var hasError: Bool = false

    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscription()
    }
    
    
    //this is the function that actually register an user to bind our data with the view
    //this listen to the data that will be published
    
    func create() {
        //we call the data from our register publisher using sink
        service
            .register(with: newUser)
            .sink { [weak self] res in
                //if there i an error we chankge the state to failure throwing an error
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            }
        //if we are in success we set the state to successful
    receiveValue: { [weak self] in
                self?.state = .successfullyRegistered
            }
            .store(in: &subscriptions)
    }
}

private extension RegistrationViewModelImpl {
    
    func setupErrorSubscription() {
        $state
            .map { state -> Bool in
                switch state {
                case .successfullyRegistered,
                     .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
