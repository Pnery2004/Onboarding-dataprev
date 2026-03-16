const { createProxyMiddleware } = require('http-proxy-middleware');
const proxyTarget = process.env.REACT_APP_PROXY_TARGET || 'http://localhost:8080';

module.exports = function(app) {
    app.use(
        '/api',
        createProxyMiddleware({
            target: proxyTarget,
            changeOrigin: true,
            logLevel: 'debug'
        })
    );
};