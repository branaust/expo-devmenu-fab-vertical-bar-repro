import ExpoModulesCore
import UIKit

/// Presents a full-screen navigation controller whose content opts out of the
/// iPhone Duo vertical bar (`preferredVerticalBarBehavior = .disabled`,
/// iOS 27.1). On the outer display, UIKit should then lay the bar items out in
/// a horizontal navigation bar and return the status bar to the horizontal axis.
public class VerticalBarProbeModule: Module {
  public func definition() -> ModuleDefinition {
    Name("VerticalBarProbe")

    AsyncFunction("present") { (disabled: Bool) in
      guard let presenter = Self.topViewController() else { return }
      let navigation = UINavigationController(rootViewController: ProbeViewController(disabled: disabled))
      navigation.modalPresentationStyle = .fullScreen
      presenter.present(navigation, animated: true)
    }.runOnQueue(.main)
  }

  private static func topViewController() -> UIViewController? {
    let scene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
    // The app window, not the dev menu's floating button window.
    var top = scene?.windows.first { $0.windowLevel == .normal && $0.rootViewController != nil }?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}

final class ProbeViewController: UIViewController {
  private let disabled: Bool

  init(disabled: Bool) {
    self.disabled = disabled
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError() }

  @available(iOS 27.1, *)
  override var preferredVerticalBarBehavior: UIVerticalBarBehavior {
    disabled ? .disabled : .automatic
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemYellow
    navigationItem.title = disabled ? "Opted out (.disabled)" : "Default (.automatic)"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      systemItem: .close,
      primaryAction: UIAction { [weak self] _ in self?.dismiss(animated: true) }
    )
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = disabled
      ? "Expected on the outer display: horizontal status bar across the top, close button in the navigation bar."
      : "System default: status bar and close button in the vertical bar."
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
}
