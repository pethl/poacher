// Import the default Application class from Stimulus
import { Application } from "stimulus"

// Import the necessary helper for loading controllers
import { definitionsFromContext } from "stimulus"

// Create a new Stimulus application instance
const application = Application.start()

// Automatically load all controllers from the current directory
const context = require.context("./", true, /.js$/)
application.load(definitionsFromContext(context))
