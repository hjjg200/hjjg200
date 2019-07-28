
module.exports = {
    getFileTabLength: ( editor ) => {
        const languageMode = editor.buffer.getLanguageMode();
        const hasIsRowCommented = languageMode.isRowCommented;
        const rgx = /^ +./

        let tl = 0;
        if( editor.usesSoftTabs() )
            for (
                let bufferRow = 0,
                    end = Math.min( 1000, editor.buffer.getLastRow() );
                bufferRow <= end;
                bufferRow++
            ) {
                if( hasIsRowCommented && languageMode.isRowCommented(bufferRow) )
                    continue;
                const line = editor.buffer.lineForRow( bufferRow );
                if( line[0] === ' ' && rgx.test( line ) ) {
                    for( let i = 0; i < line.length; i++ ) {
                        if( line.charAt( i ) === ' ' ) tl++;
                        else break;
                    }
                    return tl;
                }
            }

        return atom.config.get( "editor.tabLength" )

    }
}