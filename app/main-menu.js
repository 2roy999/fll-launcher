'use strict'

let { server } = require('./models/server')

class MainMenuController {

    constructor() {
        this.menu = new nw.Menu()
        this.statusMenuItem = new nw.MenuItem({ label: '', enabled: false })

        this.initMenu()
        this.init()
    }

    openConfigWindow() {
        nw.Window.open('./app/config.html', {}, () => {})
    }

    quit() {
        server.stop()
            .finally(() => nw.App.quit())
    }

    init() {
        server.start()
            .then(() => {
                this.statusMenuItem.label = `Status: Ok!`
            })
            .catch(() => {
                this.statusMenuItem.label = `Status: #ERROR#`
            })
    }

    initMenu() {
        this.menu.append(this.statusMenuItem)
        this.menu.append(new nw.MenuItem({ label: 'Config...', click: () => this.openConfigWindow() }))
        this.menu.append(new nw.MenuItem({ type: 'separator' }))
        this.menu.append(new nw.MenuItem({ label: 'Quit', click: () => this.quit() }))
    }
}

exports.mainMenuController = new MainMenuController()