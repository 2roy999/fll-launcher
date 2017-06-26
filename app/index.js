'use strict'

let { mainMenuController } = require('./main-menu')

exports.start = (window) => {
    let tray = new nw.Tray({ title: 'Tray', icon: './app/img/icon.ico' })
    tray.menu = mainMenuController.menu

    let win = nw.Window.get(window)
    let menuBar = new nw.Menu({ type: 'menubar' })
    menuBar.append(new nw.MenuItem({ label: 'Tray', submenu: mainMenuController.menu }))
    win.menu = menuBar
}
