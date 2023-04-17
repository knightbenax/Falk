//
//  DialogView.swift
//  Falk
//
//  Created by Bezaleel Ashefor on 17/04/2023.
//

import SwiftUI

struct DialogView: View {
    var body: some View {
        VStack(alignment: .center){
            Text("Text Copied").frame(maxWidth: .infinity, maxHeight: .infinity)
        }.padding(15).frame(minWidth: 140).frame(minHeight: 40).background(.ultraThinMaterial).cornerRadius(24).shadow(color: .black.opacity(0.5), radius: 5).padding(15).fixedSize() 
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView()
    }
}

class DialogViewHostingController: NSHostingController<DialogView> {
    @objc required dynamic init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DialogView())
    }
}


