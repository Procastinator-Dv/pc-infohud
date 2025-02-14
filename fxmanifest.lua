fx_version 'cerulean'
game 'gta5'

author 'Procastinator' 
version '2.0'

description 'Custom Info Hud'

lua54 'yes'

client_scripts {
    'client.lua',
}

ui_page {
    'html/index.html',
}

files {
	'html/index.html',
   	'html/app.js', 
    'html/styles.css',
    'html/img/*.png' 
  }

  escrow_ignore {
    'html/index.html',
}