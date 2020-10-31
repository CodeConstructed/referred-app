//
//  SearchRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

private protocol SearchRequestManagerProtocol {
    func search<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping (Result<Res, LemmyGenericError>) -> Void)
}

extension RequestsManager: SearchRequestManagerProtocol {
    func search<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: LemmyEndpoint.Site.search.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
