//
//  CalendarUI+Extensions.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import AppKit
import Cocoa
import Foundation

extension CalendarUI {
  class TextField: NSTextField {
    private var originalTextColor: NSColor?

    var urlString: String?

    override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      self.originalTextColor = textColor
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.originalTextColor = textColor
    }

    var linkEnabled: Bool = false {
      didSet {
        if linkEnabled {
          originalTextColor = self.textColor
          super.textColor = linkColor
        } else {
          super.textColor = originalTextColor
        }
      }
    }

    override var textColor: NSColor? {
      get { originalTextColor }
      set {
        originalTextColor = newValue

        if !linkEnabled {
          super.textColor = newValue
        }
      }
    }

    var linkColor = NSColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1) {
      didSet {
        if linkEnabled {
          super.textColor = linkColor
        }
      }
    }

    override func resetCursorRects() {
      guard linkEnabled else { return super.resetCursorRects() }
      addCursorRect(bounds, cursor: .pointingHand)
    }

    override func mouseUp(with event: NSEvent) {
      guard linkEnabled else {
        if let tg = target, let ac = action { sendAction(ac, to: tg) }
        return super.mouseUp(with: event)
      }

      let pointInWindow = event.locationInWindow
      let pointInView = convert(pointInWindow, from: nil)
      guard NSPointInRect(pointInView, bounds) else { return }
      let mURLString = urlString ?? stringValue
      let url: URL?
      if mURLString.hasPrefix("http://") || mURLString.hasPrefix("https://") {
        url = URL(string: mURLString)
      } else {
        url = URL(string: "http://\(mURLString)")
      }
      guard url != nil else { return }
      NSWorkspace.shared.open(url!)
    }
  }
}

extension CalendarUI {
  class Button: NSButton {
    var backgroundColor: NSColor?

    override var intrinsicContentSize: NSSize { image?.size ?? super.intrinsicContentSize }
    override var image: NSImage? {
      didSet {
        guard let mImage = image else { return }
        alternateImage = NSImage(size: mImage.size, flipped: false, drawingHandler: { dstRect -> Bool in
          mImage.draw(in: dstRect)
          NSColor.controlAccentColor.set()
          dstRect.fill(using: .sourceAtop)
          return true
        })
      }
    }

    override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)

      commonInit()
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)

      commonInit()
    }

    private func commonInit() {
      isBordered = false
      imagePosition = .imageOnly
      setButtonType(.momentaryChange)
    }
  }
}

@objc
protocol CalendarUITableViewDelegate: NSTabViewDelegate {
  @objc optional func tableView(_ tableView: CalendarUI.TableView, didHoverOverRow: Int)
}

extension CalendarUI {
  class TableView: NSTableView {
    private var trackingArea: NSTrackingArea?

    var isEnableHover: Bool = true {
      didSet {
        guard oldValue != isEnableHover else { return }
        if !isEnableHover {
          hovingRow = -1
        }
        evaluateForHighlight()
      }
    }

    private(set) var hovingRow: Int = -1 {
      didSet {
        guard oldValue != hovingRow else { return }
        if (delegate as? CalendarUITableViewDelegate)?
          .responds(to: #selector(CalendarUITableViewDelegate.tableView(_:didHoverOverRow:))) == true
        {
          (delegate as? CalendarUITableViewDelegate)?.tableView?(self, didHoverOverRow: hovingRow)
        }
        setNeedsDisplay(bounds)
      }
    }

    override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)

      commonInit()
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)

      commonInit()
    }

    private func commonInit() {
      // Notify when enclosing scrollView scrolls.
      NotificationCenter.default.addObserver(self, selector: #selector(scrollViewScrolled), name: NSView.boundsDidChangeNotification, object: enclosingScrollView?.contentView)
    }

    deinit {
      NotificationCenter.default.removeObserver(self)
      if let tracking = trackingArea {
        removeTrackingArea(tracking)
      }
    }

    @objc
    private func scrollViewScrolled() { evaluateForHighlight() }
  }
}

extension CalendarUI.TableView {
  private func evaluateForHighlight() {
    guard isEnableHover else { return }
    guard let mousePointInWindow = window?.mouseLocationOutsideOfEventStream else { return }
    let mousePoint = convert(mousePointInWindow, from: nil)
    evaluateForHighligthAtMousePoint(mousePoint)
  }

  private func evaluateForHighligthAtMousePoint(_ point: NSPoint) {
    guard isEnableHover else { return }
    guard !(window?.occlusionState.contains(.visible) ?? true) else { return }
    let hoverRow = row(at: point)
    guard hoverRow != hovingRow else { return }

    if hoverRow < 0 || hoverRow >= numberOfRows { hovingRow = -1 }
    else {
      hovingRow = hoverRow
    }
  }

  private func evaluateForHighligthAtMouseEvent(_ event: NSEvent) {
    let mousePointInWindow = event.locationInWindow
    let mousePoint = convert(mousePointInWindow, from: nil)
    evaluateForHighligthAtMousePoint(mousePoint)
  }

  // Prevent context menu highlight from drawing.
  // stackoverflow.com/a/30594427/111418
  func drawContextMenuHighlightForRow(_: Int) {}

  override func mouseEntered(with event: NSEvent) {
    evaluateForHighligthAtMouseEvent(event)
  }

  override func mouseMoved(with event: NSEvent) {
    evaluateForHighligthAtMouseEvent(event)
  }

  override func mouseExited(with _: NSEvent) {
    hovingRow = -1
  }

  override func updateTrackingAreas() {
    if let tracking = trackingArea {
      removeTrackingArea(tracking)
    }
    createTrackingArea()
    super.updateTrackingAreas()
  }

  func createTrackingArea() {
    guard let clipRect = enclosingScrollView?.contentView.bounds else { return }
    let mTracking = NSTrackingArea(rect: clipRect, options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
    addTrackingArea(mTracking)
    trackingArea = mTracking
  }
}
