// JavaScript Document
(function (h, o, g) {
    var p = function () {
        for (var b = /audio(.min)?.js.*/, a = document.getElementsByTagName('script'), c = 0, d = a.length; c < d; c++) {
            var e = a[c].getAttribute('src');
            if (b.test(e)) return e.replace(b, '')
        }
    }();
    g[h] = {
        instanceCount: 0,
        instances: {
        },
        flashSource: '      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="$1" width="1" height="1" name="$1" style="position: absolute; left: -1px;">         <param name="movie" value="$2?playerInstance=' + h + '.instances[\'$1\']&datetime=$3">         <param name="allowscriptaccess" value="always">         <embed name="$1" src="$2?playerInstance=' +
        h + '.instances[\'$1\']&datetime=$3" width="1" height="1" allowscriptaccess="always">       </object>',
        settings: {
            autoplay: false,
            loop: false,
            preload: true,
            imageLocation: '/STATIC/wechat/image/play_audio.png',
            swfLocation: p + 'audiojs.swf',
            useFlash: function () {
                var b = document.createElement('audio');
                return !(b.canPlayType && b.canPlayType('audio/mpeg;').replace(/no/, ''))
            }(),
            hasFlash: function () {
                if (navigator.plugins && navigator.plugins.length && navigator.plugins['Shockwave Flash']) return true;
                 else if (navigator.mimeTypes && navigator.mimeTypes.length) {
                    var b =
                    navigator.mimeTypes['application/x-shockwave-flash'];
                    return b && b.enabledPlugin
                } else try {
                    new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
                    return true
                } catch (a) {
                }
                return false
            }(),
            createPlayer: {
                markup: '             <div class="play-pause">             <p class="play"></p>             <p class="pause"></p>             <p class="loading"></p>             <p class="error"></p>           </div>           <div class="scrubber">             <div class="progressaa"></div>             <div class="progress"><em class="played">00:00</em></div>             <div class="loaded"></div>           </div>           <div class="time"><strong class="duration">00:00</strong>           </div>           <div class="error-message"></div>',
                playPauseClass: 'play-pause',
                scrubberClass: 'scrubber',
                progressaaClass: 'progressaa',
                progressClass: 'progress',
                loaderClass: 'loaded',
                timeClass: 'time',
                durationClass: 'duration',
                playedClass: 'played',
				closingClass: 'closing',
                errorMessageClass: 'error-message',
                playingClass: 'playing',
                loadingClass: 'loading',
                errorClass: 'error'
            },
            css: '       .audiojs audio { position: absolute; left: -1px; }         .audiojs { width: 100%; height: 17px; overflow: hidden; font-size: 12px; position:relative; padding:110px 0 0;}         .audiojs .play-pause { width: 71px; height: 71px; overflow: hidden; position:absolute; top:0; left:50%; margin-left:-35px;}         .audiojs p { display: none; width: 71px; height: 71px; cursor: pointer; background:url("$1") no-repeat;}         .audiojs .play { display: block; }         .audiojs .scrubber { position: relative; height: 5px; background: #41b5ff;}           .audiojs .progressaa{ position: absolute; top: 0px; left: 0px; height: 5px; width: 0px; background: #41b5ff; z-index: 1;}         .audiojs .progress { position: absolute; top:-11px; left: 0px; height: 26px; width: 68px; border:solid 1px #c6d0d5; border-radius:13px; background:#ffffff; z-index: 1;}     .audiojs .progress .played { display:block; text-align:center; width:68px; height:26px; line-height:26px; color: #002756; font-size:16px; font-style: normal;}         .audiojs .loaded { position: absolute; top: 0px; left: 0px; height: 5px; width: 0px; background: #41b5ff;}         .audiojs .time { display:none; width:70px; height: 26px; line-height: 26px; position:absolute; top:100px; left:0; z-index:4; text-align:center;}         .audiojs .time em { color: #002756; font-size:16px; font-style: normal;}         .audiojs .time strong { display:none; font-weight: normal; }         .audiojs .error-message { float: left; display: none; margin: 0px 10px; width: auto; height: 24px; line-height: 24px; overflow: hidden; white-space: nowrap; color: #ff0000;           text-overflow: ellipsis; -o-text-overflow: ellipsis; -icab-text-overflow: ellipsis; -khtml-text-overflow: ellipsis; -moz-text-overflow: ellipsis; -webkit-text-overflow: ellipsis; }         .audiojs .error-message a { color: #eee; text-decoration: none; padding-bottom: 1px; border-bottom: 1px solid #999; white-space: wrap; }                 .audiojs .play { background-position: 0 0;}         .audiojs .loading { background-position: 0 0;}         .audiojs .error { background-position: 0 0;}         .audiojs .pause { background-position: 0 0;}                 .playing .play, .playing .loading, .playing .error { display: none; }         .playing .pause { display: block; }                 .loading .play, .loading .pause, .loading .error { display: none; }         .loading .loading { display: block; }                 .error .time, .error .play, .error .pause, .error .scrubber, .error .loading, .error .playname { display: none; }         .error .error { display: block; }         .error .play-pause p { cursor: auto; }         .error .error-message { display: block; }',
            trackEnded: function () {
            },
            flashError: function () {
                var b = this.settings.createPlayer,
                a = j(b.errorMessageClass, this.wrapper),
                c = 'Missing <a href="http://get.adobe.com/flashplayer/">flash player</a> plugin.';
                if (this.mp3) c += ' <a href="' + this.mp3 + '">Download audio file</a>.';
                g[h].helpers.removeClass(this.wrapper, b.loadingClass);
                g[h].helpers.addClass(this.wrapper, b.errorClass);
                a.innerHTML = c
            },
            loadError: function () {
                var b = this.settings.createPlayer,
                a = j(b.errorMessageClass, this.wrapper);
                g[h].helpers.removeClass(this.wrapper, b.loadingClass);
                g[h].helpers.addClass(this.wrapper, b.errorClass);
                a.innerHTML = 'Error loading: "' + this.mp3 + '"'
            },
            init: function () {
                g[h].helpers.addClass(this.wrapper, this.settings.createPlayer.loadingClass);
            },
            loadStarted: function () {
                var b = this.settings.createPlayer,
                a = j(b.durationClass, this.wrapper),
                c = Math.floor(this.duration / 60),
                d = Math.floor(this.duration % 60);
                g[h].helpers.removeClass(this.wrapper, b.loadingClass);
                //a.innerHTML = (c < 10 ? '0' : '') + c + ':' + (d < 10 ? '0' : '') + d
                a.innerHTML = ''
            },
            loadProgress: function (b) {
                var a = this.settings.createPlayer,
                c = j(a.scrubberClass, this.wrapper);
                j(a.loaderClass, this.wrapper).style.width = (c.offsetWidth-68) * b + 'px'
            },
            playPause: function () {
                this.playing ? this.settings.play()  : this.settings.pause()
            },
            play: function () {
                g[h].helpers.addClass(this.wrapper, this.settings.createPlayer.playingClass)
            },
            pause: function () {
                g[h].helpers.removeClass(this.wrapper, this.settings.createPlayer.playingClass)
            },
			controlVolume: function(){
				this.closing ? this.setting.openVolume() : this.setting.closeVolume()
			},
			openVolume: function(){
				g[h].helpers.removeClass(this.wrapper, this.settings.createPlayer.closingClass)
			},
			closeVolume: function(){
				g[h].helpers.addClass(this.wrapper, this.settings.createPlayer.closingClass)
			},
            updatePlayhead: function (b) {
                var a = this.settings.createPlayer,
                c = j(a.scrubberClass, this.wrapper);
                j(a.progressaaClass, this.wrapper).style.width =
                    (c.offsetWidth-68) * b + 'px';
                j(a.progressClass, this.wrapper).style.left =
                    (c.offsetWidth-68) * b + 'px';
                a = j(a.playedClass, this.wrapper);
                c = this.duration * b;
                b = Math.floor(c / 60);
                c = Math.floor(c % 60);
                a.innerHTML = (b < 10 ? '0' : '') + b + ':' + (c < 10 ? '0' : '') + c
            }
        },
        create: function (b, a) {
            a = a || {};
            return b.length ? this.createAll(a, b)  : this.newInstance(b, a)
        },
        createAll: function (b, a) {
            var c = a || document.getElementsByTagName('audio'),
            d = [];
            b = b || {};
            for (var e = 0, i = c.length; e < i; e++)
				d.push(this.newInstance(c[e], b));
            return d;
        },
        newInstance: function (b, a) {
            var c = this.helpers.clone(this.settings),
            d = 'audiojs' + this.instanceCount,
            e = 'audiojs_wrapper' + this.instanceCount;
            this.instanceCount++;
            if (b.getAttribute('autoplay') != null) c.autoplay = true;
            if (b.getAttribute('loop') != null) c.loop = true;
            if (b.getAttribute('preload') == 'none') c.preload = false;
            a && this.helpers.merge(c, a);
            if (c.createPlayer.markup) b = this.createPlayer(b, c.createPlayer, e);
             else b.parentNode.setAttribute('id', e);
            e = new g[o](b, c);
            c.css && this.helpers.injectCss(e, c.css);
            if (c.useFlash && c.hasFlash) {
                this.injectFlash(e, d);
                this.attachFlashEvents(e.wrapper, e)
            } else c.useFlash && !c.hasFlash &&
            this.settings.flashError.apply(e);
            if (!c.useFlash || c.useFlash && c.hasFlash) this.attachEvents(e.wrapper, e);
            return this.instances[d] = e
        },
        createPlayer: function (b, a, c) {
            var d = document.createElement('div'),
            e = b.cloneNode(true);
            d.setAttribute('class', 'audiojs');
            d.setAttribute('className', 'audiojs');
            d.setAttribute('id', c);
            if (e.outerHTML && !document.createElement('audio').canPlayType) {
                e = this.helpers.cloneHtml5Node(b);
                d.innerHTML = a.markup;
                d.appendChild(e);
                b.outerHTML = d.outerHTML;
                d = document.getElementById(c)
            } else {
                d.appendChild(e);
                d.innerHTML += a.markup;
                b.parentNode.replaceChild(d, b)
            }
            return d.getElementsByTagName('audio') [0]
        },
        attachEvents: function (b, a) {
            if (a.settings.createPlayer) {
                var c = a.settings.createPlayer,
                d = j(c.playPauseClass, b),
                e = j(c.scrubberClass, b);
                g[h].events.addListener(d, 'click', function () {
                    a.playPause.apply(a)
                });
                g[h].events.addListener(e, 'click', function (i) {
                    i = i.clientX;
                    var f = this,
                    k = 0;
                    if (f.offsetParent) {
                        do k += f.offsetLeft;
                        while (f = f.offsetParent)
                    }
                    a.skipTo((i - k) / e.offsetWidth)
                });
                if (!a.settings.useFlash) {
                    g[h].events.trackLoadProgress(a);
                    g[h].events.addListener(a.element, 'timeupdate', function () {
                        a.updatePlayhead.apply(a)
                    });
                    g[h].events.addListener(a.element, 'ended', function () {
                        a.trackEnded.apply(a)
                    });
                    g[h].events.addListener(a.source, 'error', function () {
                        clearInterval(a.readyTimer);
                        clearInterval(a.loadTimer);
                        a.settings.loadError.apply(a)
                    })
                }
            }
        },
        attachFlashEvents: function (b, a) {
            a.swfReady = false;
            a.load = function (c) {
                a.mp3 = c;
                a.swfReady && a.element.load(c)
            };
            a.loadProgress = function (c, d) {
                a.loadedPercent = c;
                a.duration = d;
                a.settings.loadStarted.apply(a);
                a.settings.loadProgress.apply(a, [
                    c
                ])
            };
            a.skipTo = function (c) {
                if (!(c > a.loadedPercent)) {
                    a.updatePlayhead.call(a, [
                        c
                    ]);
                    a.element.skipTo(c)
                }
            };
            a.updatePlayhead = function (c) {
                a.settings.updatePlayhead.apply(a, [
                    c
                ])
            };
            a.play = function () {
                if (!a.settings.preload) {
                    a.settings.preload = true;
                    a.element.init(a.mp3)
                }
                a.playing = true;
                a.element.pplay();
                a.settings.play.apply(a)
            };
            a.pause = function () {
                a.playing = false;
                a.element.ppause();
                a.settings.pause.apply(a)
            };
            a.setVolume = function (c) {
                a.element.setVolume(c)
            };
            a.loadStarted = function () {
                a.swfReady =
                true;
                a.settings.preload && a.element.init(a.mp3);
                a.settings.autoplay && a.play.apply(a)
            }
        },
        injectFlash: function (b, a) {
            var c = this.flashSource.replace(/\$1/g, a);
            c = c.replace(/\$2/g, b.settings.swfLocation);
            c = c.replace(/\$3/g, + new Date + Math.random());
            var d = b.wrapper.innerHTML,
            e = document.createElement('div');
            e.innerHTML = c + d;
            b.wrapper.innerHTML = e.innerHTML;
            b.element = this.helpers.getSwf(a)
        },
        helpers: {
            merge: function (b, a) {
                for (attr in a) if (b.hasOwnProperty(attr) || a.hasOwnProperty(attr)) b[attr] = a[attr]
            },
            clone: function (b) {
                if (b ==
                null || typeof b !== 'object') return b;
                var a = new b.constructor,
                c;
                for (c in b) a[c] = arguments.callee(b[c]);
                return a
            },
            addClass: function (b, a) {
                RegExp('(\\s|^)' + a + '(\\s|$)').test(b.className) || (b.className += ' ' + a)
            },
            removeClass: function (b, a) {
                b.className = b.className.replace(RegExp('(\\s|^)' + a + '(\\s|$)'), ' ')
            },
            injectCss: function (b, a) {
                for (var c = '', d = document.getElementsByTagName('style'), e = a.replace(/\$1/g, b.settings.imageLocation), i = 0, f = d.length; i < f; i++) {
                    var k = d[i].getAttribute('title');
                    if (k && ~k.indexOf('audiojs')) {
                        f =
                        d[i];
                        if (f.innerHTML === e) return;
                        c = f.innerHTML;
                        break
                    }
                }
                d = document.getElementsByTagName('head') [0];
                i = d.firstChild;
                f = document.createElement('style');
                if (d) {
                    f.setAttribute('type', 'text/css');
                    f.setAttribute('title', 'audiojs');
                    if (f.styleSheet) f.styleSheet.cssText = c + e;
                     else f.appendChild(document.createTextNode(c + e));
                    i ? d.insertBefore(f, i)  : d.appendChild(styleElement)
                }
            },
            cloneHtml5Node: function (b) {
                var a = document.createDocumentFragment(),
                c = a.createElement ? a : document;
                c.createElement('audio');
                c = c.createElement('div');
                a.appendChild(c);
                c.innerHTML = b.outerHTML;
                return c.firstChild
            },
            getSwf: function (b) {
                b = document[b] || window[b];
                return b.length > 1 ? b[b.length - 1] : b
            }
        },
        events: {
            memoryLeaking: false,
            listeners: [
            ],
            addListener: function (b, a, c) {
                if (b.addEventListener) b.addEventListener(a, c, false);
                 else if (b.attachEvent) {
                    this.listeners.push(b);
                    if (!this.memoryLeaking) {
                        window.attachEvent('onunload', function () {
                            if (this.listeners) for (var d = 0, e = this.listeners.length; d < e; d++) g[h].events.purge(this.listeners[d])
                        });
                        this.memoryLeaking = true
                    }
                    b.attachEvent('on' +
                    a, function () {
                        c.call(b, window.event)
                    })
                }
            },
            trackLoadProgress: function (b) {
                if (b.settings.preload) {
                    var a,
                    c;
                    b = b;
                    var d = /(ipod|iphone|ipad)/i.test(navigator.userAgent);
                    a = setInterval(function () {
                        if (b.element.readyState > - 1) d || b.init.apply(b);
                        if (b.element.readyState > 1) {
                            b.settings.autoplay && b.play.apply(b);
                            clearInterval(a);
                            c = setInterval(function () {
                                b.loadProgress.apply(b);
                                b.loadedPercent >= 1 && clearInterval(c)
                            })
                        }
                    }, 10);
                    b.readyTimer = a;
                    b.loadTimer = c
                }
            },
            purge: function (b) {
                var a = b.attributes,
                c;
                if (a) for (c = 0; c < a.length; c +=
                1) if (typeof b[a[c].name] === 'function') b[a[c].name] = null;
                if (a = b.childNodes) for (c = 0; c < a.length; c += 1) purge(b.childNodes[c])
            },
            ready: function () {
                return function (b) {
                    var a = window,
                    c = false,
                    d = true,
                    e = a.document,
                    i = e.documentElement,
                    f = e.addEventListener ? 'addEventListener' : 'attachEvent',
                    k = e.addEventListener ? 'removeEventListener' : 'detachEvent',
                    n = e.addEventListener ? '' : 'on',
                    m = function (l) {
                        if (!(l.type == 'readystatechange' && e.readyState != 'complete')) {
                            (l.type == 'load' ? a : e) [k](n + l.type, m, false);
                            if (!c && (c = true)) b.call(a, l.type ||
                            l)
                        }
                    },
                    q = function () {
                        try {
                            i.doScroll('left')
                        } catch (l) {
                            setTimeout(q, 50);
                            return
                        }
                        m('poll')
                    };
                    if (e.readyState == 'complete') b.call(a, 'lazy');
                     else {
                        if (e.createEventObject && i.doScroll) {
                            try {
                                d = !a.frameElement
                            } catch (r) {
                            }
                            d && q()
                        }
                        e[f](n + 'DOMContentLoaded', m, false);
                        e[f](n + 'readystatechange', m, false);
                        a[f](n + 'load', m, false)
                    }
                }
            }()
        }
    };
    g[o] = function (b, a) {
        this.element = b;
        this.wrapper = b.parentNode;
        this.source = b.getElementsByTagName('source') [0] || b;
        this.mp3 = function (c) {
            var d = c.getElementsByTagName('source') [0];
            return c.getAttribute('src') || (d ? d.getAttribute('src')  : null)
        }(b);
        this.settings = a;
        this.loadStartedCalled = false;
        this.loadedPercent = 0;
        this.duration = 1;
        this.playing = false;
		this.closing = false;
		/*alert(this.mp3);
		var url=this.mp3;
		url=url.split("/");
		var playname=url[url.length-1];
		alert(playname);
		document.getElementsByTagName('span')[0].innerHTML=playname;*/
    };
    g[o].prototype = {
        updatePlayhead: function () {
            this.settings.updatePlayhead.apply(this, [
                this.element.currentTime / this.duration
            ])
        },
        skipTo: function (b) {
            if (!(b > this.loadedPercent)) {
                this.element.currentTime = this.duration * b;
                this.updatePlayhead()
            }
        },
        load: function (b) {
            this.loadStartedCalled = false;
            this.source.setAttribute('src', b);
            this.element.load();
            this.mp3 = b;
            g[h].events.trackLoadProgress(this);
        },
        loadError: function () {
            this.settings.loadError.apply(this)
        },
        init: function () {
            this.settings.init.apply(this)
        },
        loadStarted: function () {
            if (!this.element.duration) return false;
            this.duration = this.element.duration;
            this.updatePlayhead();
            this.settings.loadStarted.apply(this)
        },
        loadProgress: function () {
            if (this.element.buffered != null && this.element.buffered.length) {
                if (!this.loadStartedCalled) this.loadStartedCalled = this.loadStarted();
                this.loadedPercent = this.element.buffered.end(this.element.buffered.length - 1) / this.duration;
                this.settings.loadProgress.apply(this, [
                    this.loadedPercent
                ])
            }
        },
        playPause: function () {
            this.playing ? this.pause()  : this.play()
        },
        play: function () {
            /(ipod|iphone|ipad)/i.test(navigator.userAgent) && this.element.readyState == 0 && this.init.apply(this);
            if (!this.settings.preload) {
                this.settings.preload = true;
                this.element.setAttribute('preload', 'auto');
                g[h].events.trackLoadProgress(this)
            }
            this.playing = true;
            this.element.play();
            this.settings.play.apply(this)
        },
        pause: function () {
            this.playing = false;
            this.element.pause();
            this.settings.pause.apply(this)
        },
		controlVolume: function(){
			this.closing ? this.openVolume()  : this.closeVolume()
		},
		openVolume: function(){
			this.closing = false;
			this.element.volume = 0.5;
			this.settings.openVolume.apply(this)
		},
		closeVolume: function(){
			this.closing = true;
			this.element.volume = 0;
			this.settings.closeVolume.apply(this)
		},
        setVolume: function (b) {
            this.element.volume = b
        },
        trackEnded: function () {
            this.skipTo.apply(this, [0]);
            this.settings.loop || this.pause.apply(this);
            this.settings.trackEnded.apply(this)
        }
    };
    var j = function (b, a) {
        var c = [];
        a = a || document;
        if (a.getElementsByClassName) c = a.getElementsByClassName(b);
         else {
            var d,
            e,
            i = a.getElementsByTagName('*'),
            f = RegExp('(^|\\s)' + b + '(\\s|$)');
            d = 0;
            for (e = i.length; d < e; d++) f.test(i[d].className) && c.push(i[d])
        }
        return c.length > 1 ? c : c[0]
    }
}) ('audiojs', 'audiojsInstance', this);


function getByClass(oParent, sClass){
	var aEle=document.getElementsByTagName('*');
	var i=0;
	var aResult=[];
	
	for(i=0;i<aEle.length;i++){
		if(aEle[i].className==sClass){
			aResult.push(aEle[i]);
		}
	}
	return aResult;
}