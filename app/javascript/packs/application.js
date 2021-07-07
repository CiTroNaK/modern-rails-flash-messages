// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
require("channels")

import '../css/application'

// Fontawesome
import { config, library, dom } from '@fortawesome/fontawesome-svg-core'
// Change the config to fix the flicker
config.mutateApproach = 'sync'
// Import icons
import { faInfoCircle, faCheckCircle, faExclamationCircle, faExclamationTriangle, faExternalLinkAlt } from '@fortawesome/free-solid-svg-icons'
library.add(faInfoCircle, faCheckCircle, faExclamationCircle, faExclamationTriangle, faExternalLinkAlt)
// Load icons
dom.watch()

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"
