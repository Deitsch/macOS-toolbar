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
        return [ToolbarIdentifier.segment.identifier]
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
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.view = createSegmentControl()
            return toolbarItem
        case .flexibelSpace, .space:
            return NSToolbarItem(itemIdentifier: itemIdentifier)
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
}
