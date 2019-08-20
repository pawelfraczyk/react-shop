'use strict';

module.exports = {
    mode: 'production',
    module: {
        rules: [{
            test: /\.js$/,
            exclude: /node_modules|web_modules/,
            use: [{
                loader: 'babel-loader'
            }]
        }]
    },
    devServer: {
        allowedHosts: [
            'fraczyk.eu',
            'k8s.fraczyk.eu'
        ]
    }
};