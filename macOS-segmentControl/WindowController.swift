//
//  ToolbarDelegate.swift
//  macOS-segmentControl
//
//  Created by Simon Deutsch on 15.11.21.
//

import Cocoa

enum ToolbarIdentifier: String, CaseIterable {
    case segment
    case flexibelSpace
    case space
    case button
    case nsbutton
    
    var identifier: NSToolbarItem.Identifier {
        switch self {
        case .flexibelSpace:
            return NSToolbarItem.Identifier.flexibleSpace
        case .space:
            return NSToolbarItem.Identifier.space
        default:
            return NSToolbarItem.Identifier(rawValue: rawValue)
        }
    }
    
    var icon: NSImage? {
        return NSImage(named: "favourites")
        return NSImage(systemSymbolName: "bubble.left", accessibilityDescription: nil)
    }
    
    var text: String {
        switch self {
        case .segment:
            return "segment"
        case .flexibelSpace, .space:
            return ""
        case .button:
            return "button"
        case .nsbutton:
            return "nsbutton"
        }
    }
}

class WindowController: NSWindowController, NSToolbarDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let toolbar = NSToolbar(identifier: NSToolbar.Identifier("mw-toolbar"))
        toolbar.showsBaselineSeparator = false
        toolbar.autosavesConfiguration = true
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        
        window?.toolbar = toolbar
    
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [ToolbarIdentifier.button.identifier]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return ToolbarIdentifier.allCases.map{ $0.identifier }
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let toolbarIdentifier = ToolbarIdentifier(rawValue: itemIdentifier.rawValue) else {
            print("invalid toolbar item identifier: \(itemIdentifier)")
            return nil
        }
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        switch toolbarIdentifier {
        case .segment:
            item.view = createSegmentControl()
        case .flexibelSpace, .space:
            break
        case .button:
            item.isBordered = true
            item.image = toolbarIdentifier.icon
            item.label = toolbarIdentifier.text
            item.action = #selector(buttonClick)
        case .nsbutton:
            item.label = toolbarIdentifier.text
            item.view = createNSButton(image: toolbarIdentifier.icon)
        }
        return item
    }
    
    @objc func buttonClick() {
        print("toolbar button clicked")
    }
    
    private func createSegmentControl() -> NSSegmentedControl {
        let items: [Item] = [
            Item(text: "one", icon: NSImage(named: "contact")!),
            Item(text: "two", icon: NSImage(named: "recent")!),
            Item(text: "three", icon: NSImage(named: "favourites")!)
        ]
        let segmented = NSSegmentedControl()
        
        segmented.segmentStyle = .texturedRounded
        segmented.trackingMode = .selectOne
        segmented.segmentCount = items.count
        items.enumerated().forEach { (idx, item) in
            segmented.setImage(item.icon, forSegment: idx)
            segmented.setToolTip(item.text, forSegment: idx)
            segmented.setWidth(60, forSegment: idx)
            segmented.setImageScaling(NSImageScaling.scaleProportionallyUpOrDown, forSegment: idx)
        }
        segmented.target = self
        segmented.segmentDistribution = .fit
        return segmented
    }
    
    func createNSButton(image: NSImage?) -> NSButton {
        let button = NSButton(frame: NSRect.zero)
        button.bezelStyle = .texturedRounded
        button.imagePosition = .imageOnly
        button.imageScaling = NSImageScaling.scaleProportionallyDown
        button.image = image
        button.objectValue = self
        button.target = self
        button.action = #selector(buttonClick)
        return button
    }
}
