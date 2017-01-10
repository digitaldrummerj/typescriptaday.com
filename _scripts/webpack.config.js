const webpack = require('webpack');
const path = require('path');

const configuration = {
    context: __dirname,
    devtool: '#inline-source-map',
    entry: {
        scripts: './main.ts',
        vendor: './vendor.ts'
    },
    output: {
        path: path.join(__dirname, '..', 'assets'),
        filename: 'scripts.bundle.js',
        sourceMapFilename: '[name].js.map',
        chunkFilename: '[id].chunk.js'
    },
    module: {
        loaders: [
            { test: /\.(ts|tsx)$/, loader: 'ts-loader' }
        ]
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin({ names: ['vendor'].reverse(), filename: '[name].bundle.js' }),
    ],
    externals: {
        jquery: 'jQuery',
        foundation: 'Foundation',
        motionUI: 'MotionUI'
    },
    resolve: {
        extensions: ['', '.ts', '.json', '.js']
    }
};

module.exports = configuration;