const SelectList = require( "atom-select-list" )
const Indent = require( "./indent" )

module.exports =
class Selector {
    constructor() {
        this.view = new SelectList( {
            itemsClassList: ['mark-active'],
            items: [],
            filterKeyForItem: ( it ) => it,
            elementForItem: ( it ) => {
                const el = document.createElement( 'li' )
                const id = Indent.parse( it )
                if( id.size == this.currentIndent.size
                    && id.soft == this.currentIndent.soft ) {
                    el.classList.add( 'active' )
                }

                const indentName = id.alias()
                el.textContent = indentName
                el.dataset.indent = indentName
                return el
            },
            didConfirmSelection: ( it ) => {
                this.cancel()
                const indent = Indent.parse( it )
                const editor = atom.workspace.getActiveTextEditor()
                if( editor ) {
                    editor.setTabLength( indent.size )
                    editor.setSoftTabs( indent.soft )
                }
            },
            didCancelSelection: () => {
                this.cancel()
            }
        } )
        this.view.element.classList.add( 'indent-selector' )
    }

    destroy() {
        this.cancel()
        return this.view.destroy()
    }

    cancel() {
        if( this.panel != null ) {
            this.panel.destroy()
        }
        this.panel = null
        this.currentIndent = null
        if( this.previouslyFocusedElement ) {
            this.previouslyFocusedElement.focus()
            this.previouslyFocusedElement = null
        }
    }

    attach() {
        this.previouslyFocusedElement = document.activeElement
        if( this.panel == null ) {
            this.panel = atom.workspace.addModalPanel( { item: this.view } )
        }
        this.view.focus()
        this.view.reset()
    }

    async toggle() {
        if( this.panel != null ) {
            this.cancel()
        } else if (atom.workspace.getActiveTextEditor()) {
            this.editor = atom.workspace.getActiveTextEditor()
            this.currentIndent = {
                size: this.editor.getTabLength(),
                soft: this.editor.getSoftTabs()
            }

            let indents = atom.config.get( 'indent-selector.indents' )
            indents.sort()
            await this.view.update( { items: indents } )
            this.attach()
        }
    }

}