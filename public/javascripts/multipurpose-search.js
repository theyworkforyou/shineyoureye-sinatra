var looksLikePuNumber = function(str) {
    return /^[0-9.:/-]+$/.test(str);
};

var parseParams = function (str) {
    return str.split('&').reduce( function(params, param) {
        var paramSplit = param.split('=').map( function(value) {
            return decodeURIComponent(value.replace(/\+/g, ' '));
        });
        params[paramSplit[0]] = paramSplit[1];
        return params;
    }, {});
};

var getQueryStringValue = function (key) {
    if ( window.location.search ) {
        var params = parseParams( window.location.search.substr(1) );
        if ( params.hasOwnProperty(key) ) {
            return params[key];
        }
    }
    return '';
};

$(function() {
    $('.js-multipurpose-search').each( function() {
        var $form = $(this);
        var $q = $form.find('input[type="search"]');
        var $label = $form.find('.js-multipurpose-search-label');

        $form.on('submit', function(e) {
            var q = $.trim( $q.val() );
            if ( ! looksLikePuNumber(q) ) {
                e.preventDefault();
                window.location.href = '/search/?' + $.param({q: q});
            }
        });

        $label.text('Enter a name, location, or Polling Unit (PU) number');

        var q = getQueryStringValue('q');
        if ( q ) {
            $q.val(q);
        }
    });
});
