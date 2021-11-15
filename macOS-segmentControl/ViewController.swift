//
//  ViewController.swift
//  macOS-segmentControl
//
//  Created by Simon Deutsch on 11.11.21.
//

import Cocoa

struct Item {
    let text: String
    let icon: NSImage
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segControl = createSegmentControl()
        view.addSubview(segControl)
        segControl.centerInSuperview()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func createSegmentControl() -> NSSegmentedControl {
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
        if #available(OSX 10.13, *) {
            segmented.segmentDistribution = .fit
        }
        return segmented
    }
}

extension ViewController: NSToolbarDelegate {
    
}
