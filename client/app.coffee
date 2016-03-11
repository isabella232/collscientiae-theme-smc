# require "bootstrap/dist/css/bootstrap.css"
require "bootstrap/scss/bootstrap.scss"

require './style.sass'

$ = require "jquery"
_ = require "lodash"


main = ->
    $("#test123").html("abc")

    $ul = $("#test").append("ul")
    for x in [0...10]
        $ul.append("<li>#{x}</li>")

$(document).ready main
