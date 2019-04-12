import RxSwift

example(of: "map") {
    Observable.of(1,2,3)
        .map { $0 * $0 }
        .subscribe(onNext: {
            print($0)
        })
        .dispose()
}

example(of: "flatMap & flatMapLatest") {
    
    struct Player {
        let score: Variable<Int>
    }
    
    let disposeBag = DisposeBag()
    
    let scott = Player(score: Variable(80))
    let lori = Player(score: Variable(90))
    
    let currentPlayer = Variable(scott)
    
    currentPlayer.asObservable()
        .flatMapLatest {  $0.score.asObservable() }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    currentPlayer.value.score.value = 85
    scott.score.value = lori.score.value  * 2
    
    currentPlayer.value = lori
    scott.score.value = 100
}

example(of: "scan & buffer") {
    
    let disposeBag = DisposeBag()
    
    let dartScore = PublishSubject<Int>()
    
    dartScore
        .buffer(timeSpan: 0.0, count: 3, scheduler: MainScheduler.instance)
        .map {
            print($0, "=> ", terminator: "")
            return $0.reduce(0, +)
        }
        .scan(501, accumulator: - )
        .map{ max($0, 0) }
        .subscribe(onNext: {
            print($0)
        })
    .disposed(by: disposeBag)
    
    dartScore.onNext(13)
    dartScore.onNext(60)
    dartScore.onNext(50)

}
