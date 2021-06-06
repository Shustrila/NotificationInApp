import UIKit


@objc protocol NotificationViewDelegate: AnyObject {
    @objc optional func notificationView(willTouches: NotificationView) -> Void
    @objc optional func notificationView(didTouches: NotificationView)  -> Void
    @objc optional func notificationView(avatarTouches: NotificationView) -> Void
}


class NotificationView: UIView {
    weak var delegate: NotificationViewDelegate?
    // MARK: - Views

    var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "avatar")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Optima", size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Optima", size: 12)
        label.textColor = .white
        label.numberOfLines = 2
        label.alpha = 0.5
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Optima", size: 10)
        label.textColor = .white
        label.alpha = 0.5
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    // MARK: - Gesture Recognizers
    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupForView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupForView()
    }
    
    deinit {
        avatarImage.gestureRecognizers?.forEach({ recognizer in
            avatarImage.removeGestureRecognizer(recognizer)
        })
    }
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        delegate?.notificationView?(willTouches: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transform = CGAffineTransform(scaleX: 1, y: 1)
        delegate?.notificationView?(didTouches: self)
    }
    
    @objc private func touchesAvatar(_ sender: Any) {
        delegate?.notificationView?(avatarTouches: self)
    }
    // MARK: - Setup For View

    private func setupForView() {
        backgroundColor = .darkGray
                
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchesAvatar)))
                
        addSubview(avatarImage)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            /// constraint for avatar  Image
            avatarImage.heightAnchor.constraint(equalToConstant: 50),
            avatarImage.widthAnchor.constraint(equalToConstant: 50),
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 10),
            /// constraint for date label
            dateLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            /// constraint for title label
            avatarImage.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            /// constraint for message label
            avatarImage.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10),
        ])
    }
    
    public func setText(title text: String) {
        titleLabel.text = text
    }
    
    public func setText(message text: String) {
        messageLabel.text = text
    }
    
    public func setText(date: Date) {
        dateLabel.text = "17.06.2015"
    }
}
