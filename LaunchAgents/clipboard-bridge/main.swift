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

enum RebroadcastResult {
    case notRemote   // ordinary local copy; leave it alone
    case rewritten   // remote item rewritten without the marker
    case notReady    // remote item detected, but its content hasn't arrived yet
}

func rebroadcastIfRemote(_ pasteboard: NSPasteboard) -> RebroadcastResult {
    guard let items = pasteboard.pasteboardItems else { return .notRemote }

    let isRemote = items.contains { $0.types.contains(remoteClipboardMarker) }
    guard isRemote else { return .notRemote }

    var capturedAnyData = false
    let rebuilt: [NSPasteboardItem] = items.map { oldItem in
        let newItem = NSPasteboardItem()
        for type in oldItem.types where type != remoteClipboardMarker {
            if let data = oldItem.data(forType: type) {
                newItem.setData(data, forType: type)
                capturedAnyData = true
            } else {
                // Universal Clipboard promises some types it never actually fills
                // (e.g. "iOS rich content paste pasteboard type"). Dropping these
                // is expected and harmless as long as a real type materializes.
                log("DIAG   type \(type.rawValue): data(forType:) returned nil (dropped)")
            }
        }
        return newItem
    }

    // Universal Clipboard delivers content lazily: the changeCount can bump before
    // any data is fetched from the iOS device. If we rewrite now, clearContents()
    // destroys the still-pending remote item and writeObjects() puts back an empty
    // item — the copy is lost from both Raycast *and* the clipboard. So if nothing
    // materialized, defer: leave the original in place and try again next poll.
    guard capturedAnyData else {
        log("DIAG change \(pasteboard.changeCount): remote content not materialized yet; deferring")
        return .notReady
    }

    let summary = describeContents(pasteboard, items: items)

    let beforeCount = pasteboard.changeCount
    pasteboard.clearContents()
    pasteboard.writeObjects(rebuilt)

    log("Rebroadcast Universal Clipboard item: \(summary)")
    log("DIAG   change \(beforeCount) -> \(pasteboard.changeCount); kept types=[\((pasteboard.pasteboardItems ?? []).flatMap { $0.types.map(\.rawValue) }.joined(separator: ", "))]")
    return .rewritten
}

let pasteboard = NSPasteboard.general
var lastChangeCount = pasteboard.changeCount

// When a remote item's content hasn't arrived yet we leave lastChangeCount alone so
// the next poll retries. These bound that retry so genuinely-unfetchable content
// (a promised type the device never fills) eventually stops being re-examined.
var deferredChangeCount = -1
var deferredAttempts = 0
let maxDeferredAttempts = 20  // ~10s at the current poll interval

log("clipboard-bridge started (poll interval \(pollIntervalSeconds)s)")

while true {
    let current = pasteboard.changeCount
    if current != lastChangeCount {
        switch rebroadcastIfRemote(pasteboard) {
        case .notRemote, .rewritten:
            // Bump *after* the rewrite so our own write doesn't trigger another pass.
            lastChangeCount = pasteboard.changeCount
            deferredChangeCount = -1
            deferredAttempts = 0
        case .notReady:
            // Don't advance lastChangeCount — retry on the next poll until the
            // content materializes, or until we've waited long enough to give up.
            if current == deferredChangeCount {
                deferredAttempts += 1
                if deferredAttempts >= maxDeferredAttempts {
                    log("Gave up waiting for remote content at change \(current) after \(deferredAttempts) attempts")
                    lastChangeCount = current
                    deferredChangeCount = -1
                    deferredAttempts = 0
                }
            } else {
                deferredChangeCount = current
                deferredAttempts = 1
            }
        }
    }
    Thread.sleep(forTimeInterval: pollIntervalSeconds)
}
