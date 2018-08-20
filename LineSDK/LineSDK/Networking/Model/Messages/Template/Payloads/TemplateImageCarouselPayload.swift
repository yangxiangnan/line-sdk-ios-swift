//
//  TemplateImageCarouselPayload.swift
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

public struct TemplateImageCarouselPayload: Codable, TemplateMessagePayloadTypeCompatible {
    public struct Column: Codable {
        public var imageURL: URL
        public var action: TemplateMessageAction
        
        public init(imageURL: URL, action: TemplateMessageAction)
        {
            self.imageURL = imageURL
            self.action = action
        }
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "imageUrl"
            case action
        }
    }
    
    let type = TemplateMessagePayloadType.imageCarousel
    public var columns: [Column]
    
    public init (columns: [Column] = []) {
        self.columns = columns
    }
    
    public mutating func add(column: Column) {
        columns.append(column)
    }
    
    public mutating func replaceColumn(at index: Int, with column: Column) {
        columns[index] = column
    }
}

extension Message {
    public static func templateImageCarouselMessage(
        altText: String,
        columns: [TemplateImageCarouselPayload.Column] = []) -> Message
    {
        let payload = TemplateImageCarouselPayload(columns: columns)
        let message = TemplateMessage(altText: altText, payload: .imageCarousel(payload))
        return .template(message)
    }
}