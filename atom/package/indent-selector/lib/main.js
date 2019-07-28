const SelectView = require( "./selectView" )
const StatusView = require( "./statusView" )

let commandDisposable = null
let selectView = null
let statusView = null

module.exports = {
    activate() {
        commandDisposable = atom.commands.add(
            "atom-text-editor",
            "indent-selector:show",
            () => {
                if( !selectView ) selectView = new SelectView()
                selectView.toggle()
            }
        )
    },
    deactivate() {
        if( commandDisposable ) commandDisposable.dispose()
        commandDisposable = null

        if( selectView ) selectView.destroy()
        selectView = null

        if( statusView ) statusView.destroy()
        statusView = null
    },
    consumeStatusBar( statusBar ) {
        statusView = new StatusView( statusBar )
        statusView.attach()
    }
}
