import Foundation
import PlaygroundSupport
import RxSwift

example(of: "Single") {
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func contentsOfTextFile(named name: String) -> Single<String> {
        
        return Single.deferred {
            
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                throw FileReadError.fileNotFound
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                throw FileReadError.unreadable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                throw FileReadError.encodingFailed
            }
            
            return Single.just(contents)
        }
    }
    
    contentsOfTextFile(named: "Crazy ones")
        .subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
}


example(of: "Completable") {
    let disposeBag = DisposeBag()
    
    func write(_ text: String, toFileNamed name: String) -> Completable {
        return Completable.create { completable in
            let disposable = Disposables.create { }
            
            let url = playgroundSharedDataDirectory.appendingPathComponent("\(name).txt")
            
            do {
                try text.write(to: url, atomically: false, encoding: .utf8)
                completable(.completed)
                return disposable
            } catch {
                completable(.error(error))
                return disposable
            }
        }
    }
    
    write("A Jedi must have the deepest commitment, the most serious mind. This one a long time have I watched. All his life has he looked away…to the future, to the horizon. Never his mind on where he was. Hmm? What he was doing.", toFileNamed: "Be mindful")
        .subscribe {
            switch $0 {
            case .completed:
                print("Success!")
            case .error(let error):
                print("Failed: \(error)")
            }
        }
        .disposed(by: disposeBag)
}

example(of: "Maybe") {
    
    let disposeBag = DisposeBag()
    
    enum FileWriteError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func write(_ text: String, toFileNamed name: String) -> Maybe<String> {
        return Maybe.create { maybe in
            
            let disposable = Disposables.create { }
            
            let url = playgroundSharedDataDirectory.appendingPathComponent("\(name).txt")
            
            if let handle = FileHandle(forWritingAtPath: url.path) {
                guard let readData = FileManager.default.contents(atPath: url.path),
                    let contents = String(data: readData, encoding: .utf8),
                    contents.lowercased().range(of: text.lowercased()) == nil
                    else {
                        maybe(.completed)
                        return disposable
                }
                
                handle.seekToEndOfFile()
                guard let writeData =  text.data(using: .utf8) else {
                    maybe(.error(FileWriteError.encodingFailed))
                    return disposable
                }
                
                handle.write(writeData)
                maybe(.success("Success!"))
                return disposable
            } else {
                do {
                    try text.write(to: url, atomically: false, encoding: .utf8)
                    maybe(.success("Success!"))
                    return disposable
                } catch {
                    maybe(.error(error))
                    return disposable
                }
                
            }
        }
    }
    
    write("Here’s to the crazy ones", toFileNamed: "Crazy ones")
        .subscribe { maybe in
            switch maybe {
            case .success(let element):
                print(element)
            case .completed:
                print("Completed")
            case .error(let error):
                print(error)
            }
    }
}
