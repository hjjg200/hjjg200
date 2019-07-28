const SelectView = require( "./selectView" )
const StatusView = require( "./statusView" )
const Helper = require( "./helper" )

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

        // Active editor
        this.activeItemSubscription = atom.workspace.observeActiveTextEditor( this.subscribeToActiveTextEditor.bind( this ) )

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
    },
    subscribeToActiveTextEditor( editor ) {
        if( !editor ) return;
        const sz = Helper.getFileTabLength( editor )
        const soft = editor.usesSoftTabs()
            || atom.config.get( "editor.softTabs" )

        if( atom.config.get( "indent-selector.auto-detect" ) == true ) {
            editor.setTabLength( sz )
            editor.setSoftTabs( soft )
        }
    }
}