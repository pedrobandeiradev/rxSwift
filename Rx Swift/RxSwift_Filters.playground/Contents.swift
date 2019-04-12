import RxSwift

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    let numbers = Observable.generate(initialState: 1,
                                      condition: { $0 < 101 },
                                      iterate: { $0 + 1 })
    
    numbers
        .filter { $0.isPrime() }
        .toArray()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    let searchString = Variable("")
    
    searchString.asObservable()
        .map { $0.lowercased() }
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    searchString.value = "APPLE"
    searchString.value = "apple"
    searchString.value = "banana"
    searchString.value = "APPLE"
}

example(of: "takeWhile") {
    let disposeBag = DisposeBag()
    let numbers = Observable.of(1,2,3,4,3,2,1)
    
    numbers
        .takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
