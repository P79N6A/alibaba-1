// 分页
function getPage(){
    kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',//默认值是link，可选link或者click
        click : function(n){
            this.selectPage(n);
            $("#page").val(n);
            formSub('#comment');
            return false;
        }
    });
}
// 分页
$(function(){
    kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',//默认值是link，可选link或者click
        click : function(n){
            this.selectPage(n);
            $("#page").val(n);
            formSub('#comment');
            return false;
        }
    });
});

//** 日期控件
$(function(){
    $(".start-btn").on("click", function(){
        WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',
            oncleared:function() {
                $("#activityStartTime").val("");
            },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
    })
    $(".end-btn").on("click", function(){
        WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',oncleared:function() {
            $("#activityEndTime").val("");
        },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
    })
});

function pickedStartFunc(){
    $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
}
function pickedendFunc(){
    $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
}


//** excel导出 活动标签热度
function exportactivityTagExcel() {
    window.location.href = "exportActivityByTagExcel.do?" + $("#activityTag").serialize();
}
