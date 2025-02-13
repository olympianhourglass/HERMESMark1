//
//  ContentView.swift
//  HERMESMark1
//
//  Created by Albert Yu on 2/10/25.
//

import OpenAI
import SwiftUI

let openAI = OpenAI(apiToken: "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")



struct ContentView: View {
    
    @State private var selectedCEFRLevel = "A1"
    @State private var selectedTopic = "Aerospace"
    @State private var selectedLanguage = "German"
    @State private var selectedAmount = "5"

    let CEFRLevelOptions = ["A1", "A2", "B1", "B2", "C1", "C2"]
    let availableLanguages = ["German", "French", "Japanese", "Arabic"]
    let availableTopics = ["Aerospace", "Medicine", "Sociology"]
    let amount = ["5", "10", "20"]
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                
                HStack{
                    Picker("Select an option", selection: $selectedCEFRLevel) {
                        ForEach(CEFRLevelOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu) // Ensures it appears as a dropdown
                    .padding()
                    
                    Picker("Select an option", selection: $selectedLanguage) {
                        ForEach(availableLanguages, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu) // Ensures it appears as a dropdown
                    .padding()
                }
                
                HStack {
                    
                    Picker("Select an option", selection: $selectedAmount) {
                        ForEach(amount, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu) // Ensures it appears as a dropdown
                    .padding()
                    
                    
                    Picker("Select an option", selection: $selectedTopic) {
                        ForEach(availableTopics, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu) // Ensures it appears as a dropdown
                    .padding()
                    
                }
            }
            
            
            Button("Perform Query") {
                Task {
                    let query = ChatQuery(
                        messages: [.system(.init(content: "\($selectedAmount) words related to \($selectedTopic) in \($selectedLanguage) at the \($selectedCEFRLevel) Level"))],
                        model: .gpt4_o,
                        responseFormat: .jsonSchema(name: "translations", type: HERMESTranslations.self)
                    )
                    do {
                        let result = try await openAI.chats(query: query)
//                            print (result)
                        print (result.choices.last)
                        // need to figure out how to properly receive this information in a nice pretty format
                    } catch let error as LocalizedError {
                        print(error.localizedDescription)
                    } catch {
                        print("An unknown error occurred: \(error)")
                    }
                }
            }
           
        }
        .padding()
    }
}

struct HERMESTranslations: StructuredOutput {
    
    let translations: [HERMESTranslation]
    
    static var example: Self = {
        .init(
            translations: [HERMESTranslation(nativeLanguage: "English", nativeLaguageWord: "Hello", targetLanguage: "French", targetLanguageWord: "Bonjour", pronounciation: "bownzhoor", wordFrequencyInLanguage: ".5%")]
        )
    }()

}

struct HERMESTranslation: Codable {
    let nativeLanguage: String
    let nativeLaguageWord: String
    let targetLanguage: String
    let targetLanguageWord: String
    let pronounciation: String
    let wordFrequencyInLanguage: String
}

#Preview {
    ContentView()
}
