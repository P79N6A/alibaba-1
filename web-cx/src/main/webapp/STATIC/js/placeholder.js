/*
function isSupportPlaceholder(){var input=document.createElement("input");return"placeholder"in input}function input(obj,val){var $input=obj;var val=val;$input.attr({value:val}).css({"color":"#A9A9A9"});$input.focus(function(){if($input.val()==val){$(this).attr({value:""}).css({"color":"#000000"});}}).blur(function(){if($input.val()==""){$(this).attr({value:val}).css({"color":"#A9A9A9"});}})}function fixPlaceholder(){if(!isSupportPlaceholder()){$("input").not("input[type='password']").each(function(){var self=$(this);var val=self.attr("placeholder");if(self.val()==""){input(self,val)}});$('input[type="password"]').each(function(){var pwdField=$(this);var pwdVal=pwdField.attr("placeholder");var pwdId=pwdField.attr("id");pwdField.after('<input id="'+pwdId+'1" type="text" value='+pwdVal+' autocomplete="off" />');var pwdPlaceholder=$("#"+pwdId+"1");pwdPlaceholder.show().css({"color":"#A9A9A9"});pwdField.hide();pwdPlaceholder.focus(function(){pwdPlaceholder.hide();pwdField.show();pwdField.focus()});pwdField.blur(function(){if(pwdField.val()==""){pwdPlaceholder.show();pwdField.hide()}})})}};*/

function isSupportPlaceholder() {
    var input = document.createElement("input");
    return "placeholder" in input
}
function input(obj, val) {
    var $input = obj;
    var val = val;
    $input.attr({
        value : val
    }).css({
        "color" : "#A9A9A9"
    });
    $input.focus(function () {
        if ($input.val() == val) {
            $(this).attr({
                value : ""
            }).css({
                "color" : "#000000"
            });
        }
    }).blur(function () {
        if ($input.val() == "") {
            $(this).attr({
                value : val
            }).css({
                "color" : "#A9A9A9"
            });
        }
    })
}
function fixPlaceholder() {
    if (!isSupportPlaceholder()) {
        $("input").not("input[type='password']").each(function () {
            var self = $(this);
            var val = self.attr("placeholder");
            if (self.val() == "") {
                input(self, val)
            }
        });
        $('input[type="password"]').each(function () {
            var pwdField = $(this);
            var pwdVal = pwdField.attr("placeholder");
            var pwdId = pwdField.attr("id");
            pwdField.after('<input id="' + pwdId + '1" type="text" value=' + pwdVal + ' autocomplete="off" />');
            var pwdPlaceholder = $("#" + pwdId + "1");
            pwdPlaceholder.show().css({
                "color" : "#A9A9A9"
            });
            pwdField.hide();
            pwdPlaceholder.focus(function () {
                pwdPlaceholder.hide();
                pwdField.show();
                pwdField.focus()
            });
            pwdField.blur(function () {
                if (pwdField.val() == "") {
                    pwdPlaceholder.show();
                    pwdField.hide()
                }
            })
        })
    }
};