//
//  Helper.swift
//  gymtracker Watch App
//
//  Created by Olof Jonsson on 2023-08-05.
//

import Foundation
import CoreData



class Helper {
    
    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    
//    func copyFile() {
//        // Create destination URL
//        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let destinationFileUrl = documentsUrl.appendingPathComponent("GymtrackerModel.sqlite")
//
//        do {
//            print("replacing old file")
//            try? FileManager.default.removeItem(at: destinationFileUrl)
//            // try FileManager.default.copyItem(at: location1, to: location2)
//            print("copying new file")
//
//            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
//            print("done copying")
//            DispatchQueue.main.async {
//                self.alertTitle = "Kopiering yckades"
//                self.alertMessage = "Bra bra"
//                self.updateSuccesful = true
//                //                        self.showAlert.toggle()
//                completion()
//            }
//        } catch (let writeError) {
//            DispatchQueue.main.async {
//                self.alertTitle = "Kopiering misslyckades"
//                self.alertMessage = "\(writeError)"
//                self.updateSuccesful = false
//                self.showAlert.toggle()
//            }
//            print("Error creating a file \(destinationFileUrl) : \(writeError)")
//
//    }
    
    func dostuff() {
      //  let dbFileUrl = documentsUrl.appendingPathComponent("GymtrackerModel.sqlite")
        let path = NSPersistentContainer
            .defaultDirectoryURL()
          //  .absoluteString
           // .replacingOccurrences(of: "file://", with: "")
           // .removingPercentEncoding
        
       // let dbFileUrl = documentsUrl.appendingPathComponent("GymtrackerModel.sqlite")
        let dbFileUrl = path.appendingPathComponent("GymtrackerModel.sqlite")
        print("DBFILEURL: \(dbFileUrl)")

//        guard let uploadData = try? JSONEncoder().encode(dbFileUrl) else {
//            return
//        }
        
        let order = Order(customerId: "12345",
                          items: ["Cheese pizza", "Diet soda"])
        guard let uploadData = try? JSONEncoder().encode(order) else {
            return
        }

        print("create sessionconfig")
        let sessionConfig = URLSessionConfiguration.default
        print("create session")
        let session = URLSession(configuration: sessionConfig)
        print("creating request")
        var request = URLRequest(url: URL(string: "http://192.168.0.85/stuff/GymtrackerModel.sqlite")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("request created")
        
        let task = session.uploadTask(with: request, fromFile: dbFileUrl) { data, response, error in
            // Handle response
            print("contacting server")
            //            let remoteDataPublisher = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
          
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode  else {
                    print("Download failed")
 
                    return
                }
                print("Status code: \(statusCode)")
        }
        task.resume()
    }
}

struct Order: Codable {
    let customerId: String
    let items: [String]
}
