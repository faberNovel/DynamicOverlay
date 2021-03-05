import SwiftUI

public struct DynamicOverlay<Background: View, Content: View>: View {
    
    let background: Background
    let content: Content
    
    public init(background: Background, content: Content) {
        
        self.background = background
        self.content = content
    }
    
    public var body: some View {
        
        OverlayContainerDynamicOverlayView(background: background, content: content)
    }
}
