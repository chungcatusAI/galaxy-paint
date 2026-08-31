function showPopup(popup) {
    $('#fancybox-overlay').show();
    $('#' + popup).showPopup({
        width: 280
    });
}

function closePopup() {
    $('.fancybox-skin').hide();
    $('#fancybox-overlay').hide();
    $.fancybox.close();
}


// Slideshow JS
$(function () {
    $("#slider").responsiveSlides({
        auto: true,
        pager: true,
        nav: true,
        speed: 200,
        timeout: 11000,
        namespace: "slides_container"
    });

});


$(document).ready(function () {
    
    // Newsletter
    $('#btnNewsletter').click(function () {
        var email = $('#Email').val();
        var validation = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(email);

        if (validation == false) {
            $('#Email').focus();
            return;
        }

        var dataPost = {
            "email": email
        };

        $.ajax({
            type: "POST",
            url: "/Home/NewsletterRegistration",
            data: dataPost,
            dataType: "json",
            success: function (data, textStatus, jqXHR) {
                // Stop progress
                showPopup('popupNewsletter');
                $('#Email').val('');
            },
            error: function (xhr, status, error) {
                // Stop progress bar
                showPopup('popupError');
            }
        });

    });


    // Collapse/Expand
    $('.plus').click(function () {
        var self = $(this);

        // Remove expand class
        if (self.hasClass('expand'))
        {
            self.removeClass('expand');
            self.parents('.section').find('.section-body').hide();
        }
        else
        {
            self.addClass('expand');
            self.parents('.section').find('.section-body').show();
        }
    });


    // Images sliding
    $('.thumbs > a').click(function () {
        $('.large > img').attr('src', $(this).attr('rel'));
    });
});