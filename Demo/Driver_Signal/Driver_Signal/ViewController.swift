//
//  ViewController.swift
//  Driver_Signal
//
//  Created by jiangbo on 2019/11/26.
//  Copyright © 2019 ManlyCamera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag: DisposeBag = DisposeBag.init()
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建特征序列
        let event: Driver<Void> = btn.rx.tap.asDriver()
        
        /**
         创建观察者 AnyObserver 可以用来描叙任意一种观察者。
         例如：
         打印网络请求结果：
         
         URLSession.shared.rx.data(request: URLRequest(url: url))
         .subscribe(onNext: { data in
            print("Data Task Success with count: \(data.count)")
         }, onError: { error in
            print("Data Task Error: \(error)")
         })
         .disposed(by: disposeBag)
         
         可以看作是：
         
         let observer: AnyObserver<Data> = AnyObserver { (event) in
         switch event {
         case .next(let data):
         print("Data Task Success with count: \(data.count)")
         case .error(let error):
         print("Data Task Error: \(error)")
         default:
         break
         }
         }
         
         URLSession.shared.rx.data(request: URLRequest(url: url))
         .subscribe(observer)
         .disposed(by: disposeBag)
         
         用户名提示语是否隐藏：
         
         usernameValid
         .bind(to: usernameValidOutlet.rx.isHidden)
         .disposed(by: disposeBag)
         
         可以看作是：
         
         let observer: AnyObserver<Bool> = AnyObserver { [weak self] (event) in
         switch event {
            case .next(let isHidden):
            self?.usernameValidOutlet.isHidden = isHidden
            default:
            break
         }
         }
         
         usernameValid
         .bind(to: observer)
         .disposed(by: disposeBag)
         
         
         Binder
         
         Binder 主要有以下两个特征：
         
         不会处理错误事件
         确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
         一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
         
         示例
         
         在介绍 AnyObserver 时，我们举了这样一个例子：
         
         let observer: AnyObserver<Bool> = AnyObserver { [weak self] (event) in
         switch event {
            case .next(let isHidden):
         self?.usernameValidOutlet.isHidden = isHidden
            default:
         break
            }
         }
 
         usernameValid
         .bind(to: observer)
         .disposed(by: disposeBag)
         
         由于这个观察者是一个 UI 观察者，所以它在响应事件时，只会处理 next 事件，并且更新 UI 的操作需要在主线程上执行。
         
         因此一个更好的方案就是使用 Binder：
         
         let observer: Binder<Bool> = Binder(usernameValidOutlet) { (view, isHidden) in
         view.isHidden = isHidden
         }
         
         usernameValid
         .bind(to: observer)
         .disposed(by: disposeBag)
         
         Binder 可以只处理 next 事件，并且保证响应 next 事件的代码一定会在给定 Scheduler 上执行，这里采用默认的 MainScheduler。
         
         复用
         由于页面是否隐藏是一个常用的观察者，所以应该让所有的 UIView 都提供这种观察者：
         
         extension Reactive where Base: UIView {
            public var isHidden: Binder<Bool> {
                return Binder(self.base) { view, hidden in
                    view.isHidden = hidden
                    }
                }
            }
         */
        let observer: AnyObserver<Void> = AnyObserver { (event) in
            switch event {
            case .next():
                print("on next")
            case .error(let error):
                print("Data Task Error: \(error)")
            default:
                break
            }
        }
        // 进行绑定。drive说明特征序列是Driver序列，绑定用drive，不用bind
        event.drive(observer)
        
        // 自己创建可被观察的序列
        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            return Disposables.create()
        }
        
        // 对序列进行onNext观察,onError观察，onComplete观察,dispose观察
        numbers.subscribe(onNext: { (num) in
            print("\(num)")
        }, onError: { (error) in
            print("\(error)")
        }, onCompleted: {
            print("complete")
        }) {
            print("dispose")
        }
        
        numbers.subscribe(onNext: { (num) in
            print("\(num)")
        }, onError: { (error) in
            print("\(error)")
        }, onCompleted: {
            print("complete")
        }).disposed(by: disposeBag)
        
        
        
        let disposeBag = DisposeBag()
        let first = BehaviorSubject(value: "👦🏻")
        let second = BehaviorSubject(value: "🅰️")
        let variable = Variable(first)
        
        variable.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        first.onNext("🐱")
        variable.value = second
        second.onNext("🅱️")
        first.onNext("🐶")
        
        
        let modules = [
           "1",
           "2"
        ]
        
//         let datasource = Observable.just(modules)
        
        let datasource = Observable<Int>.of(1, 2, 4, 5)
        
        datasource.map { (num) -> Bool in
                return num > 4
            }.subscribe(onNext: { (num) in
                print("num = \(num)")
            }, onError: nil, onCompleted: nil, onDisposed: nil)
       
        
        
        struct Student {
            var score: BehaviorSubject<Int>
        }
        
//        let disposeBag = DisposeBag()
        
        let ryan = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        let student = PublishSubject<Student>()
        
        student
            .flatMap {
                $0.score
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        student.onNext(ryan)
        ryan.score.onNext(85)
        
        student.onNext(charlotte)
        ryan.score.onNext(95)
        
        charlotte.score.onNext(100)
        
        
        
    }


}

struct SectionModel {
    var name: String
    var strings: [String]
    
    
}

