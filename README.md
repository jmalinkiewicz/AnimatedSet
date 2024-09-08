# Set Card Game (CS193p Assignment III)

iOS app made with Swift and SwiftUI. This project meets all requirements (see them [here](https://cs193p.sites.stanford.edu/sites/g/files/sbiybj16636/files/media/file/a3_2.pdf)) of the assignment. 

I also included a custom ViewModifier:

```swift
struct ShapePainter: ViewModifier {
    let color: SetCardGame.Card.Color
    let shade: SetCardGame.Card.Shade
    
    var bgColor: Color {
        switch color {
        case .red:
            return .red
        // Rest of the switch statement
    }
    var bgOpacity: Double {
        switch shade {
        case .solid:
            return 1
        // Rest of the switch statement
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(bgColor.opacity(bgOpacity))
    }
}

extension View {
    func shapePainter(color: SetCardGame.Card.Color, shade: SetCardGame.Card.Shade) -> some View {
        modifier(ShapePainter(color: color, shade: shade))
    }
}

```
