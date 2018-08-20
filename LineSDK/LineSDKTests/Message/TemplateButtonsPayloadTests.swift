//
//  TemplateButtonsPayloadTests.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import LineSDK

extension TemplateButtonsPayload: MessageSample {
    static var samples: [String] {
        return [
        """
        {
          "type": "buttons",
          "thumbnailImageUrl": "https://sample.com",
          "title": "title",
          "text": "text",
          "actions": [
            {
              "type": "uri",
              "label": "CALL",
              "uri": "tel:818055475287"
            },
            {
              "type": "uri",
              "label": "WEBSITE",
              "uri": "https://linecorp.com"
            }
          ]
        }
        """,
        """
        {
          "type": "buttons",
          "thumbnailImageUrl": "https://sample.com",
          "text": "text",
          "actions": [],
          "imageAspectRatio": "unknown",
          "imageSize": "unknown",
          "imageBackgroundColor": "#FF12EE"
        }
        """,
        """
        {
          "type": "buttons",
          "thumbnailImageUrl": "https://sample.com",
          "text": "text",
          "actions": [],
          "imageAspectRatio": "square",
          "imageSize": "contain",
          "imageBackgroundColor": "abcabc"
        }
        """
        ]
    }
}

class TemplateButtonsPayloadTests: XCTestCase {
    
    func testTemplateButtonsPayloadEncoding() {
        let uriAction = TemplateMessageURIAction(label: "Cacnel", uri: URL(string: "scheme://action")!)
        let action = TemplateMessageAction.URI(uriAction)
        
        var message = TemplateButtonsPayload(
            text: "hello",
            title: "world",
            actions: [action],
            defaultAction: action,
            thumbnailImageURL: URL(string: "https://sample.com"),
            imageContentMode: .aspectFit,
            imageBackgroundColor: .red,
            sender: nil)
        
        message.add(action: .URI(uriAction))
        
        let dic = TemplateMessagePayload.buttons(message).json
        assertEqual(in: dic, forKey: "type", value: "buttons")
        assertEqual(in: dic, forKey: "text", value: "hello")
        assertEqual(in: dic, forKey: "title", value: "world")
        assertEqual(in: dic, forKey: "thumbnailImageUrl", value: "https://sample.com")
        assertEqual(in: dic, forKey: "imageAspectRatio", value: "rectangle")
        assertEqual(in: dic, forKey: "imageSize", value: "contain")
        assertEqual(in: dic, forKey: "imageBackgroundColor", value: "#FF0000")
        
        XCTAssertEqual((dic["actions"] as! [Any]).count, 2)
        XCTAssertNotNil(dic["defaultAction"])
        XCTAssertNil(dic["sentBy"])
    }
    
    func testTemplateButtonsPayloadDecoding() {
        let decoder = JSONDecoder()
        let result = TemplateButtonsPayload.samplesData
            .map { try! decoder.decode(TemplateMessagePayload.self, from: $0) }
            .map { $0.asButtonsPayload! }
        XCTAssertEqual(result[0].type, .buttons)
        XCTAssertEqual(result[0].thumbnailImageURL, URL(string: "https://sample.com")!)
        XCTAssertEqual(result[0].title, "title")
        XCTAssertEqual(result[0].text, "text")
        XCTAssertEqual(result[0].actions.count, 2)
        XCTAssertNil(result[0].defaultAction)
        XCTAssertEqual(result[0].imageAspectRatio, .rectangle)
        XCTAssertEqual(result[0].imageContentMode, .aspectFill)
        
        XCTAssertEqual(result[0].actions[0].asURIAction!.label, "CALL")
        XCTAssertEqual(result[0].actions[0].asURIAction!.uri, URL(string: "tel:818055475287")!)
        XCTAssertEqual(result[0].actions[1].asURIAction!.label, "WEBSITE")
        XCTAssertEqual(result[0].actions[1].asURIAction!.uri, URL(string: "https://linecorp.com")!)
        
        XCTAssertEqual(result[1].imageAspectRatio, .rectangle)
        XCTAssertEqual(result[1].imageContentMode, .aspectFill)
        XCTAssertEqual(result[1].imageBackgroundColor, UIColor(hex6: 0xff12ee))
        
        XCTAssertEqual(result[2].imageAspectRatio, .square)
        XCTAssertEqual(result[2].imageContentMode, .aspectFit)
        XCTAssertEqual(result[2].imageBackgroundColor, .white)
    }
    
    func testMessageWrapper() {
        let action = TemplateMessageAction.URIAction(label: "action", uri: URL(string: "https://sample.com")!)
        let message = Message.templateButtonsMessage(altText: "alt", text: "Buntton", actions: [action])
        XCTAssertNotNil(message.asTemplateMessage?.payload.asButtonsPayload)
    }
}