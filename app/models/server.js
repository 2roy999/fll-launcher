'use strict'

let EventEmitter = require('events')

let machine = require('./virtual-machine')

class Server extends EventEmitter {

    constructor() {
        super()
        this._port = 80
    }

    start() {
        return machine.forwardPort(this._port)
            .then(() => machine.start())
            .then(() => {
                this._healthCheckInterval = setInterval(() => {
                    machine.isRunning()
                        .then(isRunning => {
                            if (!isRunning && !this._isStoping) {
                                this.emit('error', new Error('Virtual machine is down!'))
                            }
                        })
                }, 1000)
            })
    }

    changePort(newPort) {
        return machine.forwardPort(newPort)
            .then(() => {
                this._port = newPort
            })
    }

    stop() {
        clearInterval(this._healthCheckInterval)
        return machine.stop()
    }

    get port() {
        return this._port
    }
}

exports.server = new Server();