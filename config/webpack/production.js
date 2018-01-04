const environment = require('./environment')

module.exports = environment.toWebpackConfig({ debug: false })
