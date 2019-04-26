'use babel';

const { remote } = require( 'electron' )

function supported() {
  return process.platform == "darwin" &&
    ( process.versions.electron.charAt( 0 ) != "2" || atom.config.get( 'core.titleBar' ) == "native" )
}

export default {

  activate( state ) {
    // Observe
    atom.config.observe( 'vibrancy.vibrancy', this.vibrancy )
  },

  deactivate() {
    this.vibrancy()
  },

  vibrancy( val = null ) {
    if( !supported() ) {
      atom.notifications.addWarning( "vibrancy is not supported" )
      return
    }

    if( val ) {
      document.documentElement.classList.add( 'vibrancy' )
      remote.getCurrentWindow().setVibrancy( val )
    } else {
      document.documentElement.classList.remove( 'vibrancy' )
      remote.getCurrentWindow().setVibrancy()
    }

  }

};