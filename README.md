# SimpleVideoPlayer

A `SwiftUI` video player allowing to play a local or a remote video in a loop

```swift
SimpleVideoPlayer(url: .introMovie, loop: true)
```
or to update the state in order to perform some UI changes. In the initializer you can choose some arguments like `progress`, progress `frequency`, `loop` mode or even the completion closure to determine if the video ended  

```swift
@State private var item: CarouselItem = .first
@State private var progress: Double = 0

var body: some View {
    VStack {
        SimpleVideoPlayer(
            url: item.url, 
            progress: $progress, 
            onComplete: selectNextItem
        )
        VStack {
            Text(item.title)
            ForEach(CarouselItem.allCases) { item in
                CarouselItemRow(
                    description: item.description,
                    progress: progress(for: item)
                )
            }
        }
    }
}
``` 

![Screenshot](Simulator.gif)

