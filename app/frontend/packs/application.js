import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Styles
import "styles/application.scss"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

console.log('Hello World from Webpacker')
