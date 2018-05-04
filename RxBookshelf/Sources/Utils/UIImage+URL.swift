//
// Copyright (c) 2017 Mario Negro Martín
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

extension UIImage {
    
    /**
     Creates an UIImage from the contents of a given url.</br></br>
     <b>IMPORTANT!!:</b> call this method always inside an async task of a global queue, to avoid main thread blocking.
     */
    convenience init?(url: String) {
        
        var data: Data?
        
        if let cachedData = UIImage.cachedDataForUrl(url: url) {
            data = cachedData
        } else if let downloadedData = UIImage.dataFromUrl(url: url) {
            data = downloadedData
        }
        
        guard let finalData = data else {
            return nil
        }
        
        self.init(data: finalData)
    }
}

fileprivate extension UIImage {
    
    static func cachedDataForUrl(url: String) -> Data? {
        
        guard let _ = keyFromUrl(url: url) else {
            return nil
        }
        
        return nil // Return cached
    }
    
    static func storeData(data: Data, url: String) {
        
        guard let _ = keyFromUrl(url: url) else {
            return
        }
        
        // Cache
    }
    
    static func keyFromUrl(url: String) -> String? {
        
        // Get key as cached
        
        return url
    }
}

fileprivate extension UIImage {
    
    static func dataFromUrl(url: String) -> Data? {
        
        guard let downloadUrl = URL(string: url) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: downloadUrl) else {
            return nil
        }
        
        storeData(data: data, url: url)
        
        return data
    }
}
