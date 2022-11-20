
import Foundation

protocol MoviesURLDelegate {
    func didUpdateMoviesURL(_ moviesMenegar: MoviesURL)
    func didFailWithError(error: Error)
}

struct MoviesURL {
    let splashURL = "https://x-mode.co.il/exam/allMovies/generalDeclaration.txt"
    let movieListURL = "https://x-mode.co.il/exam/allMovies/allMovies.txt"
    var delegate: MoviesURLDelegate?
    
    //MARK: - PerformRewuest for splashURL
    func performRewuestSplashURL(with splashURL: String) {
        if let splashAPI = URL(string: splashURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: splashAPI) { data, response , error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let splash = self.parseJSONSplash(safeData) {
                        self.delegate?.didUpdateMoviesURL(splash)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - PerformRewuest for splashURL
    func performRewuestMovieList(with movieListURL: String) {
        if let movieListAPI = URL(string: movieListURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: movieListAPI) { data, response , error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let movieList = self.parseJSONMovieList(safeData) {
                        self.delegate?.didUpdateMoviesURL(movieList)
                    }
                }
            }
            task.resume()
        }
    }
    //MARK: - ParseJson SplashData
    func parseJSONSplash(_ splashData: Data) -> MoviesURL? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SplashAPI.self , from: splashData)
            let imageUrl = decodedData.imageUrl
            let videoUrl = decodedData.videoUrl
            print(imageUrl)
            print(videoUrl)
            let splash = SplashAPI(imageUrl: imageUrl, videoUrl: videoUrl)
            return MoviesURL(delegate: splash as! MoviesURLDelegate)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    //MARK: - ParseJson MovieList
    func parseJSONMovieList(_ movieListData: Data) -> MoviesURL? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieList.self , from: movieListData)
            let id = decodedData.id
            let name = decodedData.name
            let year = decodedData.year
            let category = decodedData.category
            let movie = MovieList(id: id, name: name, year: year, category: category)
            return MoviesURL(delegate: movie as! MoviesURLDelegate)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
