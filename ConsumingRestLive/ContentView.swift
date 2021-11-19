//
//  ContentView.swift
//  ConsumingRestLive
//
//  Created by Luis Javier Carranza on 16/11/21.
//

import SwiftUI


//Model

struct Response: Codable {
    var Items: [Order]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Order: Codable {
    var id: String
    var name: String
    var price: Int
}


struct ContentView: View {
    
    @State private var results = [Order]()
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    // View
    var body: some View {
        VStack {
            Button("Add Item") {
                self.addDataLive()
            }
            .padding()
            List(results, id:\.id) { song in
                
                VStack(alignment: .leading) {
                    Text(song.name)
                        .font(.headline)
               

                }
                
            }.onAppear(perform: loadData)
            
        }
    }
    
    func addDataLive() {
        let order = Order(id: "id_235", name: "3", price: 1234)
        
        // Generate the order onject into JSON Format.
        guard let encodedOrder = try? JSONEncoder().encode(order) else {
             print("Failed to decode the order into JSON ")
            return
        }
        
        // Create the URL
        guard let url = URL(string: "https://3k4aa0r0we.execute-api.us-east-2.amazonaws.com/test/data")
        else {
            print("Bad URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        // Create our HTTP request.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = encodedOrder
        
        //Send the HTTP request.
        // Create a network session
        URLSession.shared.dataTask(with: request) {data, Response, error in
            if let data = data {
                print("Success !!! Data = \(data)")
                loadData()
                return
            }
            else{
                print("Request invalid and didn't get through")
                return
            }
            
        }.resume()
        
    }
    
    

    func loadData() {
            // Create an URL.
        guard let url = URL(string: "https://3k4aa0r0we.execute-api.us-east-2.amazonaws.com/test/data")
        else {
            print("Bad URL")
            return
        }
        
        // Translate this URL to a Request.
        let requestURL = URLRequest(url: url)
        
        // Create or use a Network session.
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.Items
                    }
                }else {
                    print("Error: Decoding Data")
                }
                
            }
            else {
                print("Fetching from API failed")
            }
        }.resume()
    }// loadData
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
