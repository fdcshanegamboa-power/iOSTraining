import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didUpdateQuantity(for item: CartItem, newQuantity: Int)
}

final class CartTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CartTableViewCell"
    
    weak var delegate: CartTableViewCellDelegate?
    private var currentItem: CartItem?

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let mainStack = UIStackView()
    private let quantityStack = UIStackView()
    private let bottomStack = UIStackView()
    private let productImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2

        priceLabel.font = .preferredFont(forTextStyle: .subheadline)
        priceLabel.textColor = .secondaryLabel

        quantityLabel.font = .preferredFont(forTextStyle: .body)
        quantityLabel.textAlignment = .center
        quantityLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true

        minusButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)

        quantityStack.axis = .horizontal
        quantityStack.spacing = 8
        quantityStack.alignment = .center
        quantityStack.addArrangedSubview(minusButton)
        quantityStack.addArrangedSubview(quantityLabel)
        quantityStack.addArrangedSubview(plusButton)

        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.distribution = .equalSpacing
        bottomStack.addArrangedSubview(priceLabel)
        bottomStack.addArrangedSubview(quantityStack)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, bottomStack])
        textStack.axis = .vertical
        textStack.spacing = 6

        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.backgroundColor = .secondarySystemBackground
        productImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .top
        mainStack.addArrangedSubview(productImageView)
        mainStack.addArrangedSubview(textStack)

        contentView.addSubview(mainStack)
    }

    private func setupLayout() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    private func setupActions() {
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }

    @objc private func minusTapped() {
        guard let item = currentItem, item.quantity > 1 else { return }
        delegate?.didUpdateQuantity(for: item, newQuantity: item.quantity - 1)
    }

    @objc private func plusTapped() {
        guard let item = currentItem else { return }
        delegate?.didUpdateQuantity(for: item, newQuantity: item.quantity + 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo")
    }
    
    func configure(with item: CartItem) {
        self.currentItem = item
        titleLabel.text = item.product.title
        priceLabel.text = "$\(item.product.price)"
        quantityLabel.text = "\(item.quantity)"

        if let url = URL(string: item.product.thumbnail) {
            loadImage(from: url)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }.resume()
    }
}
