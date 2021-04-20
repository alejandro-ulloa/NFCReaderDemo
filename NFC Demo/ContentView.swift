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

struct nfcButton: UIViewRepresentable {
  @Binding var data: String
  
  typealias UIViewType = UIButton
  
  func makeUIView(context: UIViewRepresentableContext<nfcButton>) -> UIButton {
    let button = UIButton()
    button.setTitle("Read NFC", for: .normal)
    button.backgroundColor = UIColor.systemBlue
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
    return button
  }
  
  func updateUIView(_ uiView: UIButton, context: Context) {
//    Do nothing
  }
  
  func makeCoordinator() -> nfcButton.Coordinator {
    return Coordinator(data: $data)
  }
  
  class Coordinator: NSObject, NFCNDEFReaderSessionDelegate {
    
    var session: NFCNDEFReaderSession?
    @Binding var data: String
    
    init(data: Binding<String>) {
      _data = data
    }
    
    @objc func beginScan(_ sender: Any) {
      guard NFCReaderSession.readingAvailable else {
        print("error: Scanning not supported")
        return
      }
      
      session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
      session?.alertMessage = "Hold your phone near to scan"
      session?.begin()
      
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
      if let readerError = error as? NFCReaderError {
        if readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead && readerError.code != .readerSessionInvalidationErrorUserCanceled {
          print("Error nfc read: \(readerError.localizedDescription)")
        }
      }
      self.session = nil
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
      guard
        let nfcMess = messages.first,
        let record = nfcMess.records.first,
        record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
        let payload = String(data: record.payload, encoding: .utf8)
      else {
        return
      }
      
      print(payload)
      self.data = payload
    }
    
  }
  
}
