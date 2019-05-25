//票价
var price = 80;

//显示所有座位信息
var seatInfo = $("#seatInfo").val();
var seatInfoArr = seatInfo.split(",");
for(var i=0; i< seatInfoArr.length; i++){
    seatInfoArr[i] = seatInfoArr[i];
}

//显示维修座位信息
var maintananceInfo = $("#maintananceInfo").val();
var mtananceInfoArr = maintananceInfo.split(",");
for(var i=0; i< mtananceInfoArr.length; i++){
    mtananceInfoArr[i] = mtananceInfoArr[i];
}

//显示VIP座位信息
var vipInfo = $("#vipInfo").val();
var vipInfoArr = vipInfo.split(",");
for(var i=0; i< vipInfoArr.length; i++){
    vipInfoArr[i] = vipInfoArr[i];
}

$(document).ready(function() {
    var $cart = $('#selected-seats'), //座位区
        $counter = $('#counter'), //票数
        $total = $('#total'); //总计金额

    var sc = $('#seat-map').seatCharts({
        map:
            seatInfoArr,
        naming : {
            top : false,
            getLabel : function (character, row, column) {
                return column;
            }
        },
        legend : { //定义图例
            node : $('#legend'),
            items : [
                [ 'A', 'available',   '可选座' ],
                [ 'V', 'unavailable', '已售出'],
                [ 'M', 'maintain', '维修中']
            ]
        },
        click: function () { //点击事件
            if (this.status() == 'available') { //可选座
                $('<li>'+(this.settings.row+1)+'排'+this.settings.label+'座</li>')
                    .attr('id', 'cart-item-'+this.settings.id)
                    .data('seatId', this.settings.id)
                    .appendTo($cart);
                $counter.text(sc.find('selected').length+1);
                $total.text(recalculateTotal(sc)+price);
                return 'selected';
            } else if (this.status() == 'selected') { //已选中
                //更新数量
                $counter.text(sc.find('selected').length-1);
                //更新总计
                $total.text(recalculateTotal(sc)-price);
                //删除已预订座位
                $('#cart-item-'+this.settings.id).remove();
                //可选座
                return 'available';
            } else if (this.status() == 'unavailable') { //已售出
                return 'unavailable';
            } else {
                return this.style();
            }
        }
    });

    //已售出的座位
    sc.get(vipInfoArr).status('unavailable');
    //正维修的座位
    sc.get(mtananceInfoArr).status('maintain');
});

//计算总金额
function recalculateTotal(sc) {
    var total = 0;
    sc.find('selected').each(function () {
        total += price;
    });
    return total;
}