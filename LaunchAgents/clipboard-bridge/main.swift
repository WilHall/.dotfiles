import AppKit
import Foundation

// Pasteboard items arriving via iCloud Universal Clipboard carry this private
// UTI marker. Raycast's clipboard-history watcher ignores items that have it,
// which is why iOS-originated copies never show up in Raycast on macOS.
//
// We poll the pasteboard, detect items carrying the marker, and rewrite their
// content back to the pasteboard *without* the marker. The rewrite registers
// as an ordinary local copy event, so Raycast picks it up like any other.
let remoteClipboardMarker = NSPasteboard.PasteboardType("com.apple.is-remote-clipboard")

let pollIntervalSeconds: TimeInterval = 0.5

setlinebuf(stdout)
setlinebuf(stderr)

let timestampFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()

func log(_ message: String) {
    print("[\(timestampFormatter.string(from: Date()))] \(message)")
}

func describeContents(_ pasteboard: NSPasteboard, items: [NSPasteboardItem]) -> String {
    if let text = pasteboard.string(forType: .string) {
        let preview = text.prefix(60).replacingOccurrences(of: "\n", with: "\\n")
        return "text (\(text.count) chars): \"\(preview)\(text.count > 60 ? "…" : "")\""
    }
    let types = items.flatMap { $0.types.map(\.rawValue) }.joined(separator: ", ")
    return "non-text [\(types)]"
}

func rebroadcastIfRemote(_ pasteboard: NSPasteboard) {
    guard let items = pasteboard.pasteboardItems else { return }

    let isRemote = items.contains { $0.types.contains(remoteClipboardMarker) }
    guard isRemote else { return }

    let rebuilt: [NSPasteboardItem] = items.map { oldItem in
        let newItem = NSPasteboardItem()
        for type in oldItem.types where type != remoteClipboardMarker {
            if let data = oldItem.data(forType: type) {
                newItem.setData(data, forType: type)
            }
        }
        return newItem
    }

    let summary = describeContents(pasteboard, items: items)

    pasteboard.clearContents()
    pasteboard.writeObjects(rebuilt)

    log("Rebroadcast Universal Clipboard item: \(summary)")
}

let pasteboard = NSPasteboard.general
var lastChangeCount = pasteboard.changeCount

log("clipboard-bridge started (poll interval \(pollIntervalSeconds)s)")

while true {
    let current = pasteboard.changeCount
    if current != lastChangeCount {
        rebroadcastIfRemote(pasteboard)
        // Bump *after* the rewrite so our own write doesn't trigger another pass.
        lastChangeCount = pasteboard.changeCount
    }
    Thread.sleep(forTimeInterval: pollIntervalSeconds)
}
