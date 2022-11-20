
import UIKit
import AVKit
import AVFoundation
class SplashViewController: UIViewController {
    
//    let splashAPI = SplashAPI()
//    let movieList = MovieList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
     //   playVideo(url: url)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
//
//        playVideo(url: url)
//    }
//
//    func playVideo(url: URL) {
//        let player = AVPlayer(url: url)
//
//        let vc = AVPlayerViewController()
//        vc.player = player
//
//        self.present(vc, animated: true) { vc.player?.play() }
//    }
}

