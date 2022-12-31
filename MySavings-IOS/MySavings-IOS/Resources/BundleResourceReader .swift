//
//  BundleResourceReader .swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation

struct ResourceProvide {
    static let flags = "flags"
}

enum Resource {
    
    case json(String)
    
    var name : String{
        switch self {
        case .json(let string):
            return string
        }
    }
    
    var `extension` : String{
        switch self {
        case .json:
            return "json"
        }
    }
    
}


protocol ResourceReaderDelegate {
    func fetch<DataSource : Decodable>(_ resource : Resource, type : DataSource.Type) -> DataSource
}

struct BundleResourceReader : ResourceReaderDelegate {
    
    
    func fetch<DataSource : Decodable>(_ resource: Resource, type: DataSource.Type) -> DataSource  {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: resource.name, withExtension: resource.extension) else {
            fatalError("Could not find a file name \(resource.name).\(resource.extension) ")
        }
        
        do {
            let data =  try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(type.self, from: data)
            return decoded
        }catch{
           fatalError("Failure decoding the dataSource \(error)")
        }
    }
    
}
