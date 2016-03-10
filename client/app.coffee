require "bootstrap/dist/css/bootstrap.css"

require './style.sass'

$ = require "jquery"
_ = require "lodash"


main = ->
    $("#test").html("abc")

    $ul = $("#test").append("ul")
    for x in [0...10]
        $ul.append("<li>#{x}</li>")

$(document).ready main
