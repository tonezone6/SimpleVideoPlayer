
import AVKit
import SwiftUI

public struct SimpleVideoPlayer: View {
    let url: URL
    @Binding var progress: Double
    let frequency: Double
    let loop: Bool
    let onComplete: () -> Void
        
    @State private var timeObserverToken: Any?
    @State private var player = AVPlayer()
    
    public var body: some View {
        VideoPlayer(player: player)
            .aspectRatio(16/9, contentMode: .fill)
            .disabled(true)
            .onAppear(perform: prepareAndPlay)
            .onChange(of: url, perform: play)
            .onDisappear(perform: resetPlayer)
    }
    
    public init(
        url: URL,
        progress: Binding<Double> = .constant(0),
        frequency: Double = 0.1,
        loop: Bool = false,
        onComplete: @escaping () -> Void = {}
    ) {
        self.url = url
        self._progress = progress
        self.frequency = frequency
        self.loop = loop
        self.onComplete = onComplete
    }
    
    func play(url: URL) {
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
    }
}

private extension SimpleVideoPlayer {
    func prepareAndPlay() {
        addTimeObserver(seconds: frequency) { progress = $0 }
        observeEndTime(completion: onComplete)
        play(url: url)
    }
    
    func resetPlayer() {
        removeTimeObserver()
        player.pause()
        progress = 0
    }
    
    func addTimeObserver(seconds: Double, duration: @escaping (Double) -> Void) {
        let scale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: seconds, preferredTimescale: scale)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { time in
            let total = player.currentItem?.duration.seconds ?? 1
            duration(time.seconds/total)
        }
    }

    func removeTimeObserver() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            self.timeObserverToken = nil
        }
    }
    
    func observeEndTime(completion: @escaping () -> Void) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: nil,
            using: { _ in
                if loop {
                    player.seek(to: .zero)
                    player.play()
                } else {
                    completion()
                }
            }
        )
    }
}

extension URL {
    static let mixkit = URL(string: "https://assets.mixkit.co/videos/preview/mixkit-coffee-maker-making-coffee-3578-large.mp4")!
}

struct SimpleVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        SimpleVideoPlayer(url: .mixkit, loop: true)
            .frame(height: 200)
    }
}
