$.fn.random = function() {
    var randomIndex = Math.floor(Math.random() * this.length);
    return $( this[randomIndex] );
};

$.fn.loadLazyImage = function() {
    if ( $(this).attr('data-src') && ! $(this).attr('src') ) {
        $(this).attr('src', $(this).attr('data-src'));
    }
};

$(function(){
    $('.js-show-random-child').each(function(){
        var $children = $(this).children();
        $children.addClass('hidden');

        var $randomChild = $children.random();
        $randomChild.removeClass('hidden');
        $randomChild.find('[data-src]').loadLazyImage();
    });
});
