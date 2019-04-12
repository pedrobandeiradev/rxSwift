import Foundation
import RxSwift

example(of: "creating observables") {
    let mostPopular: Observable<String> = Observable<String>.just(episodeV)
    let originalTrilogy = Observable.of(episodeIV, episodeV, episodeVI)
    let prequelTrilogy = Observable.of([episodeI, episodeII, episodeIII])
    let sequelTrilogy = Observable.from([episodeVII, episodeVIII, episodeIX])
}

example(of: "subscribe") {
    let observable = Observable.of(episodeIV, episodeV, episodeVI)
    observable.subscribe(onNext: { (element) in
        print(element)
    })
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable
        .subscribe(onNext: { (element) in
            print(element)
        }, onCompleted: {
            print("Completed")
        })
}

example(of: "never") {
    let observable = Observable<Any>.never()
    observable
        .subscribe(onNext: { (element) in
            print(element)
        }, onCompleted: {
            print("Completed")
        })
}

example(of: "dispose") {
    let mostPopular = Observable.of(episodeV, episodeIV, episodeVI)
    let subscription = mostPopular.subscribe({ event in
        print(event)
    })
    
    subscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    Observable.of(episodeVII, episodeI, rogueOne)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    subject
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    
    enum MyError: Error {
        case test
    }
    
    subject.on(.next("Hello"))
    //    subject.onCompleted()
    //    subject.onError(MyError.test)
    subject.onNext("World")
    
    let newSubscription = subject.subscribe(onNext: {
        print("New subscription: ", $0)
    })
    
    subject.onNext("What's up?")
    newSubscription.dispose()
    subject.onNext("Still there?")
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "a")
    let disposeBag = DisposeBag()
    
    _ = subject
        .subscribe(onNext: {
            print(#line, $0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("b")
    
    _ = subject
        .subscribe(onNext: {
            print(#line, $0)
        })
        .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<Int>.create(bufferSize: 3)
    let disposeBag = DisposeBag()
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    
    subject.onNext(4)
    subject
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    subject.onNext(5)
    
    subject
        .subscribe(onNext: {
            print("New subscription", $0)
        })
        .disposed(by: disposeBag)
    
}

example(of: "Variable") {
    let variable = Variable("A")
    let disposeBag = DisposeBag()
    
    variable.asObservable()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    variable.value = "B"
}
