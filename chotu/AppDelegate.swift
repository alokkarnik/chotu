//
//  AppDelegate.swift
//  chotu
//
//  Created by Alok Karnik on 06/04/20.
//  Copyright © 2020 Alok Karnik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            let appleInterfaceStyle: String = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as! String
            if appleInterfaceStyle == "Dark" {
                button.image = NSImage(named:NSImage.Name("StatusBarButtonImageDark"))
            } else {
                button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            }
        }

        constructMenu()
    }

    @objc func shortenURL(_ sender: Any?) {

        let pasteBoard = NSPasteboard.general
        let matches = pasteBoard.readObjects(forClasses: [NSString.self], options: nil)
        if let matches = matches as? [NSString], matches.count > 0 {
            if let apiURL = URL(string: "https://tinyurl.com/api-create.php?url=\(matches[0])") {
                print(apiURL.absoluteString)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: apiURL) { (data, response, error) in
                    self.pasteInPB(data: data, response: response, error: error)
                }
                dataTask.resume()
            }
        }
    }

    func pasteInPB(data: Data?, response: URLResponse?, error:Error?) {
        if let data = data {
            if let URLStr = String(data: data, encoding: .utf8), URLStr != "Error" {
                let pasteBoard = NSPasteboard.general
                pasteBoard.clearContents()
                pasteBoard.writeObjects([URLStr as NSPasteboardWriting])
            }
        }
    }

    func constructMenu() {
      let menu = NSMenu()

      menu.addItem(NSMenuItem(title: "Shorten", action:#selector(shortenURL(_:)), keyEquivalent: "j"))

      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit chotu", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }
    
}

