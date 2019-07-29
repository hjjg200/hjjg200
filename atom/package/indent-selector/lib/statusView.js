const { Disposable } = require( "atom" )
const Indent = require( "./indent" )
const Helper = require( "./helper" )

module.exports =
class StatusView {
    constructor( statusBar ) {
        this.statusBar = statusBar
        this.element = document.createElement( 'indent-selector-status' )
        this.element.classList.add( 'indent-status', 'inline-block' )
        this.indentLink = document.createElement( 'a' )
        this.indentLink.classList.add( 'inline-block' )
        this.element.appendChild( this.indentLink )

        this.activeItemSubscription = atom.workspace.observeActiveTextEditor( this.subscribeToActiveTextEditor.bind( this ) )

        const clickHandler = (event) => {
            event.preventDefault()
            atom.commands.dispatch(
                atom.views.getView( atom.workspace.getActiveTextEditor() ), 'indent-selector:show'
            )
        }
        this.element.addEventListener( 'click', clickHandler )
        this.clickSubscription = new Disposable(
            () => { this.element.removeEventListener( 'click', clickHandler ) }
        )
    }

    attach() {
        if( this.tile )
            this.tile.destroy()
        this.tile = this.statusBar.addRightTile( {
            item: this.element,
            priority: 100
        } )
    }

    destroy () {
        if( this.activeItemSubscription ) {
            this.activeItemSubscription.dispose()
        }

        if( this.clickSubscription ) {
          this.clickSubscription.dispose()
        }

        if( this.tile ) {
          this.tile.destroy()
        }

        if( this.tooltip ) {
          this.tooltip.dispose()
        }
    }

    subscribeToActiveTextEditor( editor ) {
        if( this.indentSubscription ) {
            this.indentSubscription.dispose()
            this.indentSubscription = null
        }

        if( editor ) {
            this.processEditor( editor )
            let disposable
            disposable = editor.displayLayer.onDidReset( () => {
                this.processEditor( editor )
                disposable.dispose()
            } )
        }

        this.updateStatus()
    }

    processEditor( editor ) {
        editor.displayLayer.tabLengthVal = editor.displayLayer.tabLength
        editor.softTabsVal = editor.softTabs

        Object.defineProperty(
            editor.displayLayer, 'tabLength',
            { set: ( val ) => {
                editor.displayLayer.tabLengthVal = val
                console.log(val, (new Error()).stack)
                this.updateStatus()
            },
            get: () => editor.displayLayer.tabLengthVal }
        )

        Object.defineProperty(
            editor, 'softTabs',
            { set: ( val ) => {
                editor.softTabsVal = val
                this.updateStatus()
            },
            get: () => editor.softTabsVal }
        )

        if( editor ) {
            const sz = Helper.getFileTabLength( editor )
            const soft = editor.usesSoftTabs()
                || atom.config.get( "editor.softTabs" )

            if( atom.config.get( "indent-selector.auto-detect" ) == true ) {
                editor.setTabLength( sz )
                editor.setSoftTabs( soft )
            }
        }
    }

    updateStatus() {
        atom.views.updateDocument( () => {
            const editor = atom.workspace.getActiveTextEditor()

            if( editor ) {
                if( this.tooltip ) {
                    this.tooltip.dispose()
                    this.tooltip = null
                }

                const sz = editor.getTabLength()
                const sf = editor.getSoftTabs()
                const indent = new Indent( sz, sf )
                const indentName = indent.shortAlias()

                this.indentLink.textContent = indentName
                this.indentLink.dataset.indent = indentName
                this.element.style.display = ''

                let indentAlias = indent.alias()

                this.tooltip = atom.tooltips.add(
                    this.element,
                    { title: `Current indent is ${indentAlias}` }
                )
            } else {
                this.element.style.display = 'none'
            }
        } )
    }
}
