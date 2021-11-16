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
    case search
    
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
        // return NSImage(systemSymbolName: "bubble.left", accessibilityDescription: nil)
        switch self {
        case .segment, .flexibelSpace, .space, .search:
            return nil
        case .button, .nsbutton:
            return NSImage(named: "favourites")
        }
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
        case .search:
            return "search"
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
        let defaultItems: [ToolbarIdentifier] = [.search, .button]
        return defaultItems.map{ $0.identifier }
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
        
        switch toolbarIdentifier {
        case .segment:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.view = createSegmentControl()
            return item
        case .flexibelSpace, .space:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            return item
        case .button:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.isBordered = true
            item.image = toolbarIdentifier.icon
            item.label = toolbarIdentifier.text
            item.action = #selector(buttonClick)
            return item
        case .nsbutton:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = toolbarIdentifier.text
            item.view = createNSButton(image: toolbarIdentifier.icon)
            return item
        case .search:
            let item = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            item.searchField.delegate = self
            item.label = toolbarIdentifier.text
            return item
        }
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
    
    @objc func buttonClick() {
        print("toolbar button clicked")
    }
}

extension WindowController: NSSearchFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if let search = obj.object as? NSSearchField {
            searchFieldDidChange(search)
        }
    }
    func searchFieldDidChange(_ searchField: NSSearchField) {
        print("searched \(searchField.stringValue)")
    }
}
