//
//  ImageDownloader.swift
//  imgeye
//
//  Created by Никита Владимирович on 19.05.2022.
//

import Foundation
import UIKit

class ImageDownloader: NSObject {
    
    deinit {
        print("[ImageDownloader] deinit.")
        cancelDownload()
    }
    
    private var session: URLSession?
    private var downloadTask: URLSessionDownloadTask?
    private var downloadingProgessHandler: ((_ progress: Float) -> Void)?
    private var completionHandler: ((_ uiImage: UIImage?) -> Void)?
     
    func download(from url: URL, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                completionHandler(UIImage(data: data))
            }
        }
    }
    
    func download(from url: URL,
                  completionHandler: @escaping ((_ uiImage: UIImage?) -> Void),
                  downloadingProgessHandler: @escaping (_ progress: Float) -> Void
    ) {
        self.downloadingProgessHandler = downloadingProgessHandler
        self.completionHandler = completionHandler
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        downloadTask = session?.downloadTask(with: url)
        guard let downloadTask = downloadTask else {
            print("[URLSessionDownloadTask] download task initialization failed.")
            return
        }
        downloadTask.resume()
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
        session?.invalidateAndCancel()
    }
    
}

extension ImageDownloader: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        downloadingProgessHandler?(percentDownloaded)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        session.invalidateAndCancel()
        
        guard let data = readDownloadedData(of: location) else { return }
        completionHandler?(UIImage(data: data))
        print("[urlSession in ImageDownloader] Image downloaded successfuly.")
    }
    
    private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
                
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}
