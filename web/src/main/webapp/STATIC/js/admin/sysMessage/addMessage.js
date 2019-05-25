$(function(){
    var umsType = $("#umsType").val();
    if(typeof(umsType) != "undefined"){
        $("#selType").html(umsType);
    }
/*    var umsTarget=$("#umsTarget").val();
    if(typeof(umsTarget) != "undefined"){
        $("#selTarget").html(umsTarget);
    }*/
    selectModel();
});



