// JavaScript Document
$(function() {
    /**age**/
    $("#age input[type=radio]").on("click", function () {
        $(this).parent().find("input[type=radio]").prop("checked", false);
        $(this).parents("#age").find("label").removeClass("selected");
        $(this).prop("checked", true).parent().addClass("selected");
    });
    /**sex**/
    $("#sex input[type=radio]").on("click", function () {
        $(this).parent().find("input[type=radio]").prop("checked", false);
        $(this).parents("#sex").find("label").removeClass("selected");
        $(this).prop("checked", true).parent().addClass("selected");
    });
});

function showErrorMsg(msg){
    var $content = $(".content");
    var $error = $('<div class="error-bg">' +
        '<div class="error-txt"><i></i><span>'+ msg +'</span>' +
        '</div></div>');
    $content.append($error);
    var timers = setTimeout(function(){
        $error.fadeOut(function(){
            $error.remove();
            clearTimeout(timers);
        });
    }, 2000);
}