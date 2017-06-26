'use strict'

let { server } = require('./models/server')
let { ready } = require('./utils')

class ConfigController {

    constructor(window) {
        this.Window = nw.Window.get(window)
        this.portInput = window.document.querySelector('input[name=port]')
        this.form = window.document.querySelector('form')

        this.init()
    }

    init() {
        this.portInput.value = server.port

        this.form.addEventListener('submit', () => {
            this.submit()
        })
    }

    submit() {
        let port = Number(this.portInput.value)

        server.changePort(port)
            .then(() => {
                this.Window.close()
            })
    }
}

exports.start = (window) => {

    ready(window.document, () => {
        new ConfigController(window)
    })
}
