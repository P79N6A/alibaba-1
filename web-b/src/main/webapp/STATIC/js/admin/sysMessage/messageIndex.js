$(function(){
    kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',//默认值是link，可选link或者click
        click : function(n){
            this.selectPage(n);
            $("#page").val(n);
            $('#PageForm').submit();
            return false;
        }
    });
});