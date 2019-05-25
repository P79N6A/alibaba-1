/**
 * Created by minh on 2016/1/5.
 */
/*下拉刷新*/
var nextPage = 0,isAjax= 0,myScroll,
    pullUpEl, pullUpOffset;
function loaded() {
    pullUpEl = document.getElementById('pullUp');
    pullUpOffset = pullUpEl.offsetHeight;
   console.log(pullUpOffset)
    myScroll = new iScroll('wrapper', {
        scrollbarClass: 'myScrollbar',
        useTransition: false,
        onRefresh: function () {
            if (pullUpEl.className.match('loading')) {
                pullUpEl.className = '';
                pullUpEl.querySelector('.pullUpLabel').innerHTML = '上拉加载更多...';
            }
        },
        onScrollMove: function () {
            if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match('flip')) {
                pullUpEl.className = 'flip';
                pullUpEl.querySelector('.pullUpLabel').innerHTML = '松手开始更新...';
                this.maxScrollY = this.maxScrollY;
            } else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match('flip')) {
                pullUpEl.className = '';
                pullUpEl.querySelector('.pullUpLabel').innerHTML = '上拉加载更多...';
                this.maxScrollY = pullUpOffset;
            }
        },
        onScrollEnd: function () {
            if (pullUpEl.className.match('flip')) {
                if(nextPage>0){
                    pullUpEl.className = 'loading';
                    pullUpEl.querySelector('.pullUpLabel').innerHTML = '加载中...';
                     loadData(nextPage);
                    
                }else{
                	  // console.log(nextPage);
                    pullUpEl.className = 'none';
                    pullUpEl.querySelector('.pullUpLabel').innerHTML = '已无可加载的数据';
                }
             
            }
        }
    });
}
//初始化绑定iScroll控件
document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener('DOMContentLoaded', loaded, false);

function loadData(page){
    if(isAjax) {
        return;
    }
    var data={
        cat_id:0,
        lange_id:0,
        sort:"last",
        pagesize:10,
        unlearn:0,
        page:page,
        is_easy:0
    }

    if(!page||page==1){
        page=1;
    }

    isAjax=1;
    $.ajax({
        url:"userCourseList.do",
        data: data,
        method: 'post',
        dataType:'json',
        success: function(datalist){
        	var datalist=eval(datalist);
            isAjax=0;
            var data = datalist;
        	if(data.length==10){
            	nextPage=page+1;
            	}else{
            		nextPage=0;	
            	}
            var str = '';
            if(data.length > 0){         
                for(k in data) {
                	var Classname='';
                	var sSignup='';
                	if(data[k].orderStatus==1){
                		Classname='Wait';	
                		sSignup='待确认';
                	}else{
                		Classname='none';
                		sSignup='已确认';
                	};
                    str += '<li class="borderRadiu5" data-orderNum="'+data[k].orderId+'" ><div class="top clearfix"><p class="'+Classname+'"><span>'+sSignup+'</span><i></i></p>' +
                    '<h2>'+data[k].courseTitle+'</h2>' +
					'<a href="javascript:void(0);" class="cancel">取消报名</a></div>'+
                    '<div class="detail"><p class="title">【报名时间】</p><p class="info">'+ data[k].createTime.substring(0,19) +'</p>' +
                    '<p class="title">【培训地点】</p><p class="info">'+ data[k].trainAddress +'</p>' +
                    '<i class="time">【培训时间】:'+ data[k].startTime +'至'+data[k].endTime+'&nbsp;&nbsp;'+data[k].trainTime+'</i></div></li>';
                }
            }else{
            	isAjax=0;
    			nextPage=0;
    			//$(".pullUpLabel").html('已无可加载的数据');
                str = page == 1 ? '<div class="nodata"></div>' : '';
            }
           if(page == 1) {  //如果是第一页
                if($("#like-list").html() == ''){
                    setTimeout(function(){
                        $("#like-list").html(str);
                        myScroll.refresh();
                    }, 0);
                }else{
                    setTimeout(function(){
                        $("#like-list").html(str);
                        myScroll.refresh();
                    }, 100);
                }
                $('.js-next').remove();
                $("html,body").animate({scrollTop:0},200);
            }else{
                setTimeout(function(){
                    $('.js-next').remove();
                    $("#like-list").append(str);
                    myScroll.refresh();
                }, 500);
            }
           console.log(nextPage)
        },
        error:function(){
            isAjax=0;
			nextPage=0;
            setTimeout(function(){
                $(".js-next").remove();
            },500);
        },
        complete:function(){
            isAjax=0;
        }
    });

}

$(function(){
    loadData(1);
});