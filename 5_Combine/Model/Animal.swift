//
//  Animal.swift
//

import Foundation
import UIKit

struct Animal: Codable, Hashable {
    let animalId: Int
    let place: String
    let kind: String
    let sex: String
    let bodytype: String
    let colour: String
    let age: String
    let status: String
    let remark: String
    let opendate: String
    let shelterName: String
    let albumFile: String
    let shelterAddress: String
    let shelterTel: String
    let animalVariety: String
    let areaPkid: Int
    let animalSterilization: String
    let title: String
    let cDate: String
    let albumUpdate: String
    
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case animalId = "animal_id"
        case place = "animal_place"
        case kind = "animal_kind"
        case areaPkid = "animal_area_pkid"
        case sex = "animal_sex"
        case bodytype = "animal_bodytype"
        case colour = "animal_colour"
        case age = "animal_age"
        case status = "animal_status"
        case remark = "animal_remark"
        case opendate = "animal_opendate"
        case shelterName = "shelter_name"
        case albumFile = "album_file"
        case shelterAddress = "shelter_address"
        case shelterTel = "shelter_tel"
        case animalVariety = "animal_Variety"
        case animalSterilization = "animal_sterilization"
        case title = "animal_title"
        case cDate = "cDate"
        case albumUpdate = "album_update"
    }
}
