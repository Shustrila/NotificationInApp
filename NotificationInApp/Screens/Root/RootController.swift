import UIKit


protocol RootControllerProtocol: AnyObject {
    func setupForScreen() -> Void
    func showNotification() -> Void
    func hideNotification() -> Void
}


class RootController: UIViewController {
    // MARK: - Presenter

    public var presenter: RootPresenterProtocol!
    // MARK: - Views
    
    lazy var notificationView: NotificationView = {
        let view = NotificationView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}


extension RootController: NotificationViewDelegate {
    func notificationView(willTouches: NotificationView) {
        presenter.willTouchesNotificationView()
    }
    
    func notificationView(didTouches: NotificationView) {
        presenter.didTouchesNotificationView()
    }
    
    func notificationView(avatarTouches: NotificationView) {
        print("avatarTouches")
    }
}


extension RootController: RootControllerProtocol {
    func setupForScreen() {
        view.backgroundColor = .white
        
        notificationView.setText(title: "You a message from: Anrew")
        notificationView.setText(message: "Hey, what's up man, i want to tell the meme")
        notificationView.setText(date: Date())
        
        view.addSubview(notificationView)
        
        NSLayoutConstraint.activate([
            /// constraints for notification view
            notificationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -notificationView.bounds.size.height),
            view.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: 8),
            notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
        ])
    }
    
    func showNotification() {
        // TODO: create remove constreints

        notificationView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 40
        ).isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.notificationView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideNotification() {
        // TODO: create remove constreints

        notificationView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: -notificationView.bounds.size.height
        ).isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.notificationView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
