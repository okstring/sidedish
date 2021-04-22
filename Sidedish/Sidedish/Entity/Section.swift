//
//  Section.swift
//  Sidedish
//
//  Created by Issac on 2021/04/22.
//

import Foundation

enum Section: String, CaseIterable, Hashable {
    case main
    case soup
    case side
    
    var title: String {
        switch self {
        case .main: return "한 그릇 뚝딱 메인요리"
        case .soup: return "김이 모락모락 국, 찌개"
        case .side: return "언제 먹어도 든든한 밑반찬"
        }
    }
}
