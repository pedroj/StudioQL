import Cocoa
import QuickLookUI

class PreviewViewController: NSViewController, QLPreviewingController {

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 400))
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        guard let info = IOFileReader.readIOFile(at: url) else {
            handler(NSError(domain: "StudioQL", code: 1))
            return
        }

        let image = info.thumbnail

        // Create a custom view that draws the image scaled to fit
        let contentView = PreviewContentView(image: image, label: "Studio \(info.version) — \(info.totalParts) parts")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        handler(nil)
    }
}

class PreviewContentView: NSView {
    private let image: NSImage
    private let labelText: String

    init(image: NSImage, label: String) {
        self.image = image
        self.labelText = label
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func draw(_ dirtyRect: NSRect) {
        let bounds = self.bounds
        let labelHeight: CGFloat = 30
        let padding: CGFloat = 8

        // Image area
        let imageArea = NSRect(x: padding, y: labelHeight,
                               width: bounds.width - padding * 2,
                               height: bounds.height - labelHeight - padding)

        // Scale image to fit within imageArea, preserving aspect ratio
        let imgSize = image.size
        guard imgSize.width > 0, imgSize.height > 0, imageArea.width > 0, imageArea.height > 0 else { return }

        let scale = min(imageArea.width / imgSize.width, imageArea.height / imgSize.height)
        let drawW = imgSize.width * scale
        let drawH = imgSize.height * scale
        let drawX = imageArea.origin.x + (imageArea.width - drawW) / 2
        let drawY = imageArea.origin.y + (imageArea.height - drawH) / 2

        image.draw(in: NSRect(x: drawX, y: drawY, width: drawW, height: drawH),
                   from: .zero, operation: .sourceOver, fraction: 1.0)

        // Draw label
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.secondaryLabelColor,
            .font: NSFont.systemFont(ofSize: 13, weight: .medium)
        ]
        let str = labelText as NSString
        let strSize = str.size(withAttributes: attrs)
        let strX = (bounds.width - strSize.width) / 2
        str.draw(at: NSPoint(x: strX, y: (labelHeight - strSize.height) / 2), withAttributes: attrs)
    }
}
