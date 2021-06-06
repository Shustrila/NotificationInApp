import Foundation


protocol RootPresenterProtocol: AnyObject {
    func viewDidLoad() -> Void
    func willTouchesNotificationView() -> Void
    func didTouchesNotificationView() -> Void
}


class RootPresenter {
    // MARK: - View

    private unowned var view: RootControllerProtocol!
    // MARK: - Properties

    private var showNotificationTimer: Timer?
    private var hideNotificationTimer: Timer?
    // MARK: - Init
    
    init(view: RootControllerProtocol) {
        self.view = view
        
        createShowNotificationTimer()
    }
    
    deinit {
        showNotificationTimer?.invalidate()
        showNotificationTimer = nil
        hideNotificationTimer?.invalidate()
        hideNotificationTimer = nil
    }
    // MARK: - Timer Creators
    private func createShowNotificationTimer() {
        showNotificationTimer = Timer.scheduledTimer(
            withTimeInterval: 5,
            repeats: false,
            block: showNotificationTimerBlock
        )
    }
    
    private func createHideNotificationTimer() {
        hideNotificationTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false,
            block: hideNotificationTimerBlock
        )
    }
    
    // MARK: - Timer Blocks
    
    @objc private func showNotificationTimerBlock(_ timer: Timer) {
        view.showNotification()
        createHideNotificationTimer()

        showNotificationTimer?.invalidate()
        showNotificationTimer = nil
    }
    
    @objc private func hideNotificationTimerBlock(_ timer: Timer) {
        view.hideNotification()
        createShowNotificationTimer()
    }
}


extension RootPresenter: RootPresenterProtocol {
    func viewDidLoad() {
        view.setupForScreen()
    }
    
    func willTouchesNotificationView() {
        hideNotificationTimer?.invalidate()
        hideNotificationTimer = nil
    }
    
    func didTouchesNotificationView() {
        createHideNotificationTimer()
    }
}
