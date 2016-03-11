# Collscientiae Style for SageMathCloud
# Copyright: SageMathCloud Authors
# License: Apache 2.0

webpack = require('webpack')
path    = require('path')
fs      = require('fs')

VERSION = '1.0.0'
OUTPUT = 'build' # target dir (will get wiped before each build!)
RES = 'res'

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

# https://www.npmjs.com/package/html-webpack-plugin
HtmlWebpackPlugin = require('html-webpack-plugin')
htmlWebpackPlugin = new HtmlWebpackPlugin
                              filename: 'index.html',
                              template: 'client/index.html'

extractCSS = new ExtractTextPlugin(path.join(RES, "styles-[hash].css"))

# https://github.com/webpack/docs/wiki/optimization#multi-page-app
CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkPlugin")
commonsChunkPlugin = new CommonsChunkPlugin(path.join(RES, "common-[hash].js"))

cssConfig = JSON.stringify({discardComments: {removeAll: true}, mergeLonghand: true})

extractTextCss  = ExtractTextPlugin.extract("style", "css?sourceMap&#{cssConfig}")
extractTextSass = ExtractTextPlugin.extract("style", "css?#{cssConfig}!sass?sourceMap&indentedSyntax")
extractTextScss = ExtractTextPlugin.extract("style", "css?#{cssConfig}!sass?sourceMap")
extractTextLess = ExtractTextPlugin.extract("style", "css?#{cssConfig}!less?sourceMap")

dedupePlugin = new webpack.optimize.DedupePlugin()

plugins = [assetsPlugin, dedupePlugin, cleanWebpackPlugin, extractCSS, htmlWebpackPlugin, commonsChunkPlugin]

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
        path                : path.join(__dirname, OUTPUT)
        publicPath          : ""
        filename            : path.join(RES, '[name]-[hash].js')
        sourceMapFilename   : path.join('[file].map')
        chunkFilename       : path.join('[name]-[id]-[hash].js')

    devtool: "source-map"

    resolve:
        modulesDirectories: ["node_modules"]
        extensions: ["", ".cjsx", ".coffee", ".webpack.js", ".web.js", ".js"]

    module:
        loaders: [
            { test: /\.cjsx$/,   loaders: ['coffee', 'cjsx'] },
            { test: /\.coffee$/, loader : 'coffee?sourceMap' },
            { test: /\.less$/,   loader : extractTextLess },
            { test: /\.scss$/,   loader : extractTextScss },
            { test: /\.sass$/,   loader : extractTextSass }, # loaders: ["style", "css", "sass?sourceMap&indentedSyntax"]},
            { test: /\.json$/,   loaders: ['json'] },
            { test: /\.png$/,    loader: "url-loader?limit=100000" },
            { test: /\.(jpg|jpeg|gif)$/,    loader: "file-loader"},
            { test: /\.html$/,   loader: "html-loader"},
            { test: /\.woff(2)?(\?v=[0-9].[0-9].[0-9])?$/, loader: "url-loader?mimetype=application/font-woff" },
            { test: /\.(ttf|eot|svg)(\?v=[0-9].[0-9].[0-9])?$/, loader: "file-loader?name=[name].[ext]" },
            { test: /\.css$/, loader: extractTextCss }
        ]

    resolve:
        extensions: ['', '.webpack.js', '.web.js', '.coffee', '.js', '.scss', '.sass']
        modulesDirectories: ['client', 'node_modules']

    plugins: plugins
