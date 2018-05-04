
import UIKit
import RxSwift

protocol ActivityIndicatorHandler {
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorHandler where Self: UIViewController {    
    func showActivityIndicator() {
        let indicator = createIndicatorView()
        view.isUserInteractionEnabled = false
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func hideActivityIndicator() {
        guard let indicator = view.viewWithTag(kIndicatorViewTag) else { return }
        indicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }

    private func createIndicatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = kIndicatorViewTag
        view.backgroundColor = kBackgroundLayerColor
        view.layer.cornerRadius = kBackgroundLayerCornerRadius
        view.widthAnchor.constraint(equalToConstant: kBackgroundLayerSide).isActive = true
        view.heightAnchor.constraint(equalToConstant: kBackgroundLayerSide).isActive = true

        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return view
    }
}

extension ObservableType {
    func showActivityIndicator(in handler: ActivityIndicatorHandler) -> Observable<E> {
        return self.do(onNext: { _ in
            handler.showActivityIndicator()
        })
    }
    
    func hideActivityIndicator(in handler: ActivityIndicatorHandler) -> Observable<E> {
        return self.do(onNext: { _ in
            handler.hideActivityIndicator()
        })
    }
}

fileprivate let kIndicatorViewTag = 1
fileprivate let kBackgroundLayerColor = UIColor.black.withAlphaComponent(0.5)
fileprivate let kBackgroundLayerSide: CGFloat = 80
fileprivate let kBackgroundLayerCornerRadius: CGFloat = 10
