/**
 * Created by minh on 2015/6/29.
 */
(function($){
    /*文化地图左侧滚动条*/
    $(window).load(function(){
        setScroll();
    });
    $(window).resize(function(){
        setScroll();
    });
})(jQuery);

function setScroll(){
    var $leftTree = $("#left-tree");
    if($leftTree.length > 0) {
        var leftTreeH = $(window).height()-170;
        $leftTree.height(leftTreeH);
        var realityH = $leftTree.find(".tree-panel").height();
        if(realityH > leftTreeH) {
            var $scrollbar = $("#mCSB_1_scrollbar_horizontal");
            if ($scrollbar.length > 0) {
                $scrollbar.show();
            } else {
                $.mCustomScrollbar.defaults.scrollButtons.enable = true;
                $.mCustomScrollbar.defaults.axis = "yx";
                $leftTree.mCustomScrollbar();
            }
        }
    }
}

var timer = null;
$(function(){
    $(".tree-panel").on("click", "a.tree-node", function(){
        clearTimeout(timer);
        var that = $(this);
        var thatParent = $(this).parent();
        var thatParentSiblings = thatParent.siblings();
        if(that.hasClass("tree-index")){
            thatParent.addClass("tree-selected").siblings().removeClass("tree-selected");
        }else{
            thatParent.addClass("tree-selected").siblings().removeClass("tree-selected");
            if(that.find(".tree-icon").hasClass("tree-collapsed")) {
                that.find(".tree-icon").removeClass("tree-collapsed").addClass("tree-expanded");
                thatParent.addClass("tree-selected").siblings().removeClass("tree-selected");
                if(that.hasClass("tree-node2")){  /*第三级菜单*/
                    that.siblings(".tree-child2").slideDown(500);
                    thatParentSiblings.find(".tree-node2 .tree-icon").removeClass("tree-expanded").addClass("tree-collapsed");
                    thatParentSiblings.find(".tree-child2").slideUp(500);
                }else{  /*第二级菜单*/
                    that.siblings(".tree-child").slideDown(500);
                    thatParentSiblings.find(".tree-child:not(.tree-child2)").slideUp(500);
                    thatParentSiblings.find(".tree-node:not(.tree-node2,.tree-index) .tree-icon").removeClass("tree-expanded").addClass("tree-collapsed");
                }
            }else if(that.find(".tree-icon").hasClass("tree-expanded")){
                if(that.hasClass("tree-node2")){  /*第三级菜单*/
                    that.siblings(".tree-child2").slideUp(500,function(){
                        that.find(".tree-icon").removeClass("tree-expanded").addClass("tree-collapsed");
                    });
                }else{  /*第二级菜单*/
                    that.siblings(".tree-child").slideUp(500,function(){
                        that.find(".tree-icon").removeClass("tree-expanded").addClass("tree-collapsed");
                    });
                }
            }
        }
        timer = setTimeout(setScroll, 501);
    });

    $(".tree-child,.tree-child2").on("click", "a[target=main]", function(){
        $(".tree-panel").find(".tree-node-selected").removeClass("tree-node-selected");
        $(this).addClass("tree-node-selected");
    });
});
