//
//  MessagesViewLocal.swift
//  Lab14IntroFirebase
//
//  Stub view used when the full MessagesView cannot be compiled.
//

import SwiftUI

struct MessagesViewLocal: View {
    var body: some View {
        Text("Mensajes (stub)")
            .font(.title)
            .foregroundColor(.primary)
    }
}

#if DEBUG
struct MessagesViewLocal_Previews: PreviewProvider {
    static var previews: some View {
        MessagesViewLocal()
    }
}
#endif
