//
//  CreateFolioModelView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 29/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import Foundation

struct CreateFolioModelView : Codable {
    
    var type:String
    var title:String
    var description:String
    var number:String
    var firstAddress:String
    var city:String
    var region:String
    var country:String
    var highlighturls:[String]
    var email:String
    var customFolioType:String
    var fax:String
    var socialMediaData:[String]
    var isAddressPublic:Bool
    var isPhonePublic:Bool
    var logo:[Data]
    var members: String

    
    enum CodingKeys: String, CodingKey {
        case type = "folio_data[type]"
        case title = "folio_data[title]"
        case description = "folio_data[description]"
        case number = "folio_data[number]"
        case city = "folio_data[city]"
        case region = "folio_data[region]"
        case country = "folio_data[country]"
        case email = "folio_data[email]"
        case fax = "folio_data[fax]"
        case highlighturls = "folio_data[highlight_urls][]"
        case firstAddress = "folio_data[first_address]"
        case customFolioType = "folio_data[custom_folio_type]"
        case socialMediaData = "folio_data[social_media_data][]"
        case isAddressPublic = "folio_data[is_address_public]"
        case isPhonePublic = "folio_data[is_phone_public]"
        case logo = "folio_data[logo][]"
        case members = "members[]"
    }
    
//    init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        type = try container.decodeIfPresent(String.self, forKey: .type)!
//        title = try container.decodeIfPresent(String.self, forKey: .title)!
//        description = try container.decodeIfPresent(String.self, forKey: .description)!
//        number = try container.decodeIfPresent(String.self, forKey: .number)!
//        city = try container.decodeIfPresent(String.self, forKey: .city)!
//        region = try container.decodeIfPresent(String.self, forKey: .region)!
//        country = try container.decodeIfPresent(String.self, forKey: .country)!
//        email = try container.decodeIfPresent(String.self, forKey: .email)!
//        fax = try container.decodeIfPresent(String.self, forKey: .fax)!
//        highlighturls = try container.decodeIfPresent(Array.self, forKey: .highlighturls)!
//        firstAddress = try container.decodeIfPresent(String.self, forKey: .firstAddress)!
//        customFolioType = try container.decodeIfPresent(String.self, forKey: .customFolioType)!
//        socialMediaData = try container.decodeIfPresent(Array.self, forKey: .socialMediaData)!
//        isAddressPublic = try container.decodeIfPresent(Bool.self, forKey: .isAddressPublic)!
//        isPhonePublic = try container.decodeIfPresent(Bool.self, forKey: .isPhonePublic)!
//        logo = try container.decodeIfPresent(Data.self, forKey: .logo)!
//    }
    
}





