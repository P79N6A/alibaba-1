/**
 * Created by minh on 2016/1/1.
 */
/*点赞*/
/*$(function() {
    $("body").on("click", ".M-in-zan", function () {
        if ($(this).hasClass("M-love")) {
            $(this).removeClass("M-love");
        } else {
            $(this).addClass("M-love");
        }
    })
});*/
/** 发表评论**/
/*$(function(){
    $("body").on("click",".M-command",function() {
        var command_block = "M-command_box_" + $(this).attr("tip");
        var obj = $("." + command_block);
        if (obj.is(":visible")) {
            obj.hide();
        } else {
            obj.show();
        }
        if ($(".M-grid").length > 0) {
            $('#M-container').BlocksIt();
        }
    });
    $("body").on("click",".M-btn-publish",function(){
        $(this).parent(".M-form-box").hide();
        if($(".M-grid").length>0){
            $('#M-container').BlocksIt();
        }
    })
});*/


function dialogAlert(title, content, fn){
    if(top.dialog){
        dialog = top.dialog;
    }
    var d = dialog({
        width: 500,
        title:title,
        content:content,
        fixed: true,
        okValue: '确 定',
        ok: function () {
            if(fn)  fn();
        }
    });
    d.showModal();
}