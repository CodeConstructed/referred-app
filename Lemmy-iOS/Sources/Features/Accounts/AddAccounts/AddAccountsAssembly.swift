//
//  AddAccountsAssebly.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LemmyAuthMethod {
    case auth // auth mean Authentication
    case register
}

final class AddAccountsAssembly: Assembly {
    
    var completionHandler: (() -> Void)?

    private let authMethod: LemmyAuthMethod
    private let currentInstance: Instance
    
    init(
        authMethod: LemmyAuthMethod,
        currentInstance: Instance
    ) {
        self.authMethod = authMethod
        self.currentInstance = currentInstance
    }
    
    func makeModule() -> AddAccountViewController {
        let viewModel = AddAccountViewModel(
            instance: self.currentInstance
        )
        let vc = AddAccountViewController(
            viewModel: viewModel,
            authMethod: authMethod
        )
        viewModel.viewController = vc
        
        completionHandler = vc.completionHandler
        
        return vc
    }
}
