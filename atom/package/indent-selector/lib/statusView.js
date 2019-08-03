
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

        if( this.resetSubscription ) {
            this.resetSubscription.dispose()
        }

        if( this.tokenizeSubscription ) {
            this.tokenizeSubscription.dispose()
        }
    }

    subscribeToActiveTextEditor( editor ) {

        if( editor ) {
            // Reset
            this.resetSubscription = editor.displayLayer.onDidReset( () => {
                this.updateStatus()
            } )

            // Tokenized
            const languageMode = editor.buffer.getLanguageMode()
            const onDidTokenize = () => {
                //this.processEditor( editor )
                const sz = Helper.getFileTabLength( editor )
                const soft = editor.usesSoftTabs()

                if( atom.config.get( "indent-selector.auto-detect" ) == true ) {
                    editor.setTabLength( sz )
                    editor.setSoftTabs( soft )
                }
            }

            console.log( languageMode )

            if( languageMode.rootLanguageLayer ) {
                languageMode.rootLanguageLayer.update( null ).then( onDidTokenize )
            } else if( languageMode.onDidTokenize ) {
                this.tokenizeSubscription = languageMode.emitter.on( 'did-tokenize', onDidTokenize )
            }

        }

        this.updateStatus()

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
