# Collscientiae Style for SageMathCloud
# Copyright: SageMathCloud Authors
# License: Apache 2.0

webpack = require('webpack')
path    = require('path')
fs      = require('fs')

VERSION = '1.0.0'
OUTPUT = 'build' # target dir (will get wiped before each build!)

# assets.json file
AssetsPlugin = require('assets-webpack-plugin')
assetsPlugin = new AssetsPlugin
                        filename: "assets.json"
                        fullPath: yes
                        prettyPrint: true
                        metadata: version: VERSION

# a bit like like "make clean"
CleanWebpackPlugin = require('clean-webpack-plugin')
cleanWebpackPlugin = new CleanWebpackPlugin [OUTPUT],
                                            verbose: true
                                            dry: false

# https://webpack.github.io/docs/stylesheets.html
ExtractTextPlugin = require("extract-text-webpack-plugin")

plugins = [assetsPlugin, cleanWebpackPlugin, new ExtractTextPlugin("styles-[hash].css")]
if process.argv.indexOf('--minimize') != -1
    plugins.push new webpack.optimize.UglifyJsPlugin
                            minimize:true
                            comments:false
                            mangle:
                                except: ['$super', '$', 'exports', 'require']

module.exports =
    cache: true

    contentBase: "#{__dirname}/client/"

    entry:
        "main" : "./client/app"

    output:
        path                : path.join(__dirname, OUTPUT, "res")
        publicPath          : "/res/"
        filename            : '[name]-[hash].js'
        sourceMapFilename   : '[file].map'
        chunkFilename       : '[id].[hash].js'

    devtool: "source-map"

    resolve:
        modulesDirectories: ["node_modules"]
        extensions: ["", ".cjsx", ".coffee", ".webpack.js", ".web.js", ".js"]

    module:
        loaders: [
            { test: /\.cjsx$/,   loaders: ['coffee', 'cjsx'] },
            { test: /\.coffee$/, loader: 'coffee?sourceMap' },
            { test: /\.less$/,   loaders: ["style", "css", "less?sourceMap"]},
            { test: /\.sass$/,   loaders: ["style", "css", "sass?sourceMap&indentedSyntax"]},
            { test: /\.json$/,   loaders: ['json'] },
            { test: /\.png$/,    loader: "url-loader?limit=100000" },
            { test: /\.(jpg|jpeg|gif)$/,    loader: "file-loader"},
            { test: /\.html$/,   loader: "html-loader"},
            { test: /\.woff(2)?(\?v=[0-9].[0-9].[0-9])?$/, loader: "url-loader?mimetype=application/font-woff" },
            { test: /\.(ttf|eot|svg)(\?v=[0-9].[0-9].[0-9])?$/, loader: "file-loader?name=[name].[ext]" },
            { test: /\.css$/, loader: ExtractTextPlugin.extract("style", "css?sourceMap") }
        ]

    resolve:
        extensions: ['', '.webpack.js', '.web.js', '.coffee', '.js', '.scss', '.sass']
        modulesDirectories: ['client', 'node_modules']

    plugins: plugins
