const config = {
    development: {
        MONGO_HOST: 'mongodb://localhost:27017/theDb',
        MONGO_DB_NAME: 'theDb'
    },
    production: {
        MONGO_HOST: process.env.MONGO_HOST,
        MONGO_DB_NAME: process.env.MONGO_DB_NAME
    }
}

module.exports = config[process.env.NODE_ENV || 'development']