const config = {
    development: {
        SERVICE_URL: 'http://localhost:3000/'
    },
    production: {
        SERVICE_URL: 'http://localhost:3000/'
    }
}

console.log(process.env.NODE_ENV)

export default config[process.env.NODE_ENV || 'development'];