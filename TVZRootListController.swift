import Foundation
import SwiftUI

let TVZ_UICOLOR = UIColor(red: 235.0 / 255, green: 59.0 / 255, blue: 90.0 / 255, alpha: 1.0)
let TVZ_COLOR = Color(TVZ_UICOLOR)

@objc
final class TVZRootListController: PSListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarImage()

        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never

        let controller = TVZRootController()
        addChild(controller)

        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(controller.view)

        controller.didMove(toParent: self)
    }

    var hidesBarsOnSwipe = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidesBarsOnSwipe = navigationController?.hidesBarsOnSwipe ?? false
        navigationController?.hidesBarsOnSwipe = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = hidesBarsOnSwipe
    }

    func addNavigationBarImage() {
        let image = UIImage(named: "icon", in: Bundle.tvz_support, with: nil)!
        let imageView = UIImageView(image: image)
        let bannerWidth: CGFloat = 32
        let bannerHeight: CGFloat = 32
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}

final class TVZRootController: UIHostingController<TVZRootView> {
    init() {
        super.init(rootView: TVZRootView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Color {
    init(rgbString: String) {
        let components = rgbString.split(separator: ",").map { Double($0) ?? 0 }
        if components.count == 3 {
            self.init(.sRGB, red: components[0] / 255, green: components[1] / 255, blue: components[2] / 255, opacity: 1.0)
        } else {
            self.init(.sRGB, red: components[0] / 255, green: components[1] / 255, blue: components[2] / 255, opacity: components[3])
        }
    }

    func toRGBString() -> String {
        let components = self.cgColor?.components ?? [0, 0, 0, 0]
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = components[3]
        return "\(red),\(green),\(blue),\(alpha)"
    }
}

struct LabelWithImageIcon: View {
    let title: String
    let systemImage: String

    init(_ title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    var body: some View {
        Label(title: {
            Text(self.title)
                .foregroundColor(.primary)
        }, icon: {
            Image(systemName: self.systemImage)
                .renderingMode(.template)
        } )
    }
}

struct LabelWithSubtitle: View {
    let title: String
    let subtitle: String
    let systemImage: String

    init(_ title: String, subtitle: String, systemImage: String) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }

    var vStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    var body: some View {
        Label {
            if #available(iOS 16.0, *) {
                vStack
            } else {
                vStack.padding(.vertical, 4)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

struct TVZRootView: View {

    @AppStorage("isEnabled", store: TVZUserDefaults.standard)
    var isEnabled = false

    @AppStorage("isRecordingOnly", store: TVZUserDefaults.standard)
    var isRecordingOnly = false

    @AppStorage("useTrackingEffect", store: TVZUserDefaults.standard)
    var useTrackingEffect = false

    @AppStorage("useMorphEffect", store: TVZUserDefaults.standard)
    var useMorphEffect = false

    @AppStorage("fillColorString", store: TVZUserDefaults.standard)
    var fillColorString: String = "235,59,90,0.5"
    @State var fillColor: Color

    @AppStorage("borderColorString", store: TVZUserDefaults.standard)
    var borderColorString: String = "235,59,90"
    @State var borderColor: Color

    @AppStorage("animationDuration", store: TVZUserDefaults.standard)
    var animationDuration: TimeInterval = 0.3
    let minimumAnimationDuration: TimeInterval = 0
    let maximumAnimationDuration: TimeInterval = 3.0
    let animationDurationStep: TimeInterval = 0.1

    @AppStorage("fillSize", store: TVZUserDefaults.standard)
    var fillSize: Double = 40.0
    let minimumFillSize: Double = 20.0
    let maximumFillSize: Double = 60.0
    let fillSizeStep: Double = 1.0

    @AppStorage("liftScale", store: TVZUserDefaults.standard)
    var liftScale: Double = 2.0
    let minimumLiftScale: Double = 1.0
    let maximumLiftScale: Double = 5.0
    let liftScaleStep: Double = 0.1

    @AppStorage("borderWidth", store: TVZUserDefaults.standard)
    var borderWidth: Double = 3.0
    let minimumBorderWidth: Double = 0.0
    let maximumBorderWidth: Double = 10.0
    let borderWidthStep: Double = 0.1

    @State var isPresentingResetPrompt = false

    init() {
        let fillColorString = TVZUserDefaults.standard.string(forKey: "fillColorString") ?? "235,59,90,0.5"
        _fillColor = State(initialValue: Color(rgbString: fillColorString))

        let borderColorString = TVZUserDefaults.standard.string(forKey: "borderColorString") ?? "235,59,90"        
        _borderColor = State(initialValue: Color(rgbString: borderColorString))
    }

    func reload() {
        let fillColorString = TVZUserDefaults.standard.string(forKey: "fillColorString") ?? "235,59,90,0.5"
        fillColor = Color(rgbString: fillColorString)

        let borderColorString = TVZUserDefaults.standard.string(forKey: "borderColorString") ?? "235,59,90"
        borderColor = Color(rgbString: borderColorString)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("Touch-Viz", bundle: Bundle.tvz_support, comment: ""))
                        .font(.system(size: 42))
                        .fontWeight(.bold)
                        .foregroundColor(TVZ_COLOR)

                    Text(String(format: NSLocalizedString("v%@ - @Lessica", bundle: Bundle.tvz_support, comment: ""), Bundle.tvz_packageVersion))
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .listRowBackground(Color.clear)

            Section {
                Toggle(isOn: $isEnabled) {
                    LabelWithImageIcon(NSLocalizedString("Enable Touch-Viz", bundle: Bundle.tvz_support, comment: ""), systemImage: "checkmark.circle")
                        .foregroundColor(TVZ_COLOR)
                }
                .toggleStyle(SwitchToggleStyle(tint: TVZ_COLOR))

                Toggle(isOn: $isRecordingOnly) {
                    LabelWithSubtitle(
                        NSLocalizedString("Only for Recording", bundle: Bundle.tvz_support, comment: ""),
                        subtitle: NSLocalizedString("Displays touch indicators only during screen recording.", bundle: Bundle.tvz_support, comment: ""),
                        systemImage: "info.circle"
                    )
                    .foregroundColor(TVZ_COLOR)
                }
                .toggleStyle(SwitchToggleStyle(tint: TVZ_COLOR))
            } header: {
                Text(NSLocalizedString("General", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                ColorPicker(selection: $fillColor) {
                    LabelWithImageIcon(NSLocalizedString("Fill Color", bundle: Bundle.tvz_support, comment: ""), systemImage: "paintpalette")
                        .foregroundColor(TVZ_COLOR)
                }
                .onChange(of: fillColor) { color in
                    fillColorString = color.toRGBString()
                }

                ColorPicker(selection: $borderColor) {
                    LabelWithImageIcon(NSLocalizedString("Border Color", bundle: Bundle.tvz_support, comment: ""), systemImage: "circle")
                        .foregroundColor(TVZ_COLOR)
                }
                .onChange(of: borderColor) { color in
                    borderColorString = color.toRGBString()
                }
            } header: {
                Text(NSLocalizedString("Colors", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                HStack {
                    Slider(value: $fillSize, in: minimumFillSize...maximumFillSize, step: fillSizeStep)

                    Text(String(format: "%.0f pt", fillSize))
                        .font(.body.monospacedDigit())
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
            } header: {
                Text(NSLocalizedString("Fill Size", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                HStack {
                    Slider(value: $borderWidth, in: minimumBorderWidth...maximumBorderWidth, step: borderWidthStep)

                    Text(String(format: "%.1f pt", borderWidth))
                        .font(.body.monospacedDigit())
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
            } header: {
                Text(NSLocalizedString("Border Width", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                HStack {
                    Slider(value: $animationDuration, in: minimumAnimationDuration...maximumAnimationDuration, step: animationDurationStep)

                    Text(String(format: "%.1f s", animationDuration))
                        .font(.body.monospacedDigit())
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
            } header: {
                Text(NSLocalizedString("Animation Duration", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                HStack {
                    Slider(value: $liftScale, in: minimumLiftScale...maximumLiftScale, step: liftScaleStep)

                    Text(String(format: "%.1f x", liftScale))
                        .font(.body.monospacedDigit())
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
            } header: {
                Text(NSLocalizedString("Lift Scale", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                Toggle(isOn: $useTrackingEffect) {
                    LabelWithImageIcon(NSLocalizedString("Tracking Effect", bundle: Bundle.tvz_support, comment: ""), systemImage: "scribble")
                        .foregroundColor(TVZ_COLOR)
                }
                .toggleStyle(SwitchToggleStyle(tint: TVZ_COLOR))

                Toggle(isOn: $useMorphEffect) {
                    LabelWithImageIcon(NSLocalizedString("Morph Effect", bundle: Bundle.tvz_support, comment: ""), systemImage: "lasso")
                        .foregroundColor(TVZ_COLOR)
                }
                .toggleStyle(SwitchToggleStyle(tint: TVZ_COLOR))
            } header: {
                Text(NSLocalizedString("Effects", bundle: Bundle.tvz_support, comment: ""))
            }

            Section {
                Button(role: .destructive) {
                    isPresentingResetPrompt = true
                } label: {
                    Label(NSLocalizedString("Reset to Default", bundle: Bundle.tvz_support, comment: ""), systemImage: "arrow.counterclockwise")
                        .foregroundColor(TVZ_COLOR)
                }
            } footer: {
                Text(NSLocalizedString("Credits:\n@LeoNatan: LNTouchVisualizer (MIT License)", bundle: Bundle.tvz_support, comment: ""))
                    .padding(.top, 40)
                    .padding(.bottom, 8)
            }
        }
        .listStyle(.insetGrouped)
        .tint(TVZ_COLOR)
        .alert(isPresented: $isPresentingResetPrompt) {
            Alert(
                title: Text(NSLocalizedString("Reset to Default", bundle: Bundle.tvz_support, comment: "")),
                message: Text(NSLocalizedString("Are you sure you want to reset all settings to their default values?", bundle: Bundle.tvz_support, comment: "")),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text(NSLocalizedString("Reset", bundle: Bundle.tvz_support, comment: ""))) {
                    withAnimation {
                        TVZUserDefaults.standard.resetToDefaultValues()
                        reload()
                    }
                }
            )
        }
    }
}
