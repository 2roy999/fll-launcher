'use strict'

let Promise = require('bluebird')
let vbox = require('virtualbox')

const MACHINE_NAME = 'FLLscoring'
const PF_RULE_NAME = 'fllpublish'

Promise.promisifyAll(vbox)

exports.start = () => vbox.startAsync(MACHINE_NAME, false)

exports.forwardPort = port => {
    return vbox.modifyAsync(MACHINE_NAME, {
        natpf1: ['delete', PF_RULE_NAME]
    })
        .catch((err) => {
            console.error('ERROR: deleting PF rule - ', err)
        })
        .then(() => vbox.modifyAsync(MACHINE_NAME, {
            natpf1: `${PF_RULE_NAME},tcp,,${port},,80`
        }))
}

exports.isRunning = () => vbox.isRunningAsync(MACHINE_NAME)

exports.stop = () => vbox.poweroffAsync(MACHINE_NAME)