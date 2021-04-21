//
//  ContentView.swift
//  NFC Demo
//
//  Created by Alejandro Ulloa on 4/19/21.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
  
  @State var textContent = ""
  
  var body: some View {
    NavigationView {
      GeometryReader { metrics in
        VStack(alignment: .center, spacing: .none) {
          Section {
            TextField("NFC Value", text: $textContent)
              .padding(5)
              .border(Color.black)
              .padding(.horizontal, 20.0)
              .foregroundColor(.red)
          }
          Section {
            nfcButton.init(data: $textContent)
              .frame(width: metrics.size.width * 0.9, height: 50, alignment: .center)
              .cornerRadius(10)
          }
          Spacer()
        }
        .navigationBarTitle("NFC Scanner")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

