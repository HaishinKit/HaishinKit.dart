import Foundation
import HaishinKit
import RTMPHaishinKit

extension RTMPStatus {
    func makeEvent() -> [String: Any?] {
        return [
            "type": "rtmpStatus",
            "data": [
                "code": code,
                "level": level,
                "description": description
            ]
        ]
    }
}
