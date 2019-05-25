//闭包限定命名空间
;(function ($) {
    
    // boxWidth ：包裹图片的div的宽
    // boxHeight ：包裹图片的div的高

    //默认参数
    var defaluts = {
        'boxWidth': 0,
        'boxHeight': 0,
        'path':'src'
    };

    $.fn.extend({

        'picFullCentered' : function (options) {

            //使用jQuery.extend 覆盖插件默认参数
            var opts = $.extend({}, defaluts, options);
            
            //这里的this 就是 jQuery对象
            this.each(function () {

                if(opts.boxWidth && opts.boxHeight) {

                    //获取当前dom 的 jQuery对象，这里的this是当前循环的dom
                    var _this = $(this);

                    // 包裹图片的div的宽和高的比例
                    var boxWH = opts.boxWidth / opts.boxHeight;

                    var imgObj = new Image();
                    
                    // src加载完成后获取图片原始宽高
                    imgObj.onload = function () {
                        var startWidth = imgObj.width;
                        var startHeight = imgObj.height;
                        // 原始宽高比 > 指定宽高比 （宽图）【就把图片的高==指定的高，计算出宽，和向左边偏移的距离】
                        // 原始宽高比 < 指定宽高比 （长图）【就把图片的宽==指定的宽，计算出高，和向上面偏移的距离】
                        if(startWidth / startHeight >= boxWH) { // 宽图
                            // 按照指定的高，缩放后，计算出图片的宽
                            var laterWidth = (opts.boxHeight * startWidth) / startHeight;
                            // 按照计算后图片的宽 减去 指定的宽，再除以2，计算出向左边移动的距离
                            var _left = (laterWidth - opts.boxWidth) / 2 * (-1);
                            // 计算后的参数赋给图片
                            _this.css({
                                'width' : 'auto',
                                'height' : '100%',
                                'position' : 'absolute',
                                'top' : '0',
                                'left' : _left
                            });
                        } else {  // 长图
                            // 按照指定的宽，缩放后，计算出图片的高
                            var laterHeight = (opts.boxWidth * startHeight) / startWidth;
                            // 按照计算后图片的高 减去 指定的高，再除以2，计算出向上面移动的距离
                            var _top = (laterHeight - opts.boxHeight) / 2 * (-1);
                            // 计算后的参数赋给图片
                            _this.css({
                                'width' : '100%',
                                'height' : 'auto',
                                'position' : 'absolute',
                                'top' : _top,
                                'left' : '0'
                            });
                        }
                    };

                    // 应该把onload写到src前面，先告诉浏览器图片加载完要怎么处理，再让它去加载图片。 所以，不是IE浏览器不会触发onload事件，而是因为加载缓冲区的速度太快，在没有告诉它加载完要怎么办时，它已经加载完了。反过来说，firefox明显更智能一些，加入onload事件后，firefox浏览器会检测缓冲区是否已经有此图片，有的话直接就触发此事件！

                    // onload和定义src的语句应该换一下顺序，IE从缓存中取图片，onload根本不触发，opera也有这个毛病

                    // 这个必须写在imgObj.onload的后面，不然IE有BUG，无法执行imgObj.onload（）
                    imgObj.src = _this.attr(opts.path);

                }

            });
            // 返回jquery对象，使得可以链式操作
            return this;  
        }

    });
    
})(jQuery);
