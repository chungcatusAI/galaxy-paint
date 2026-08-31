function getCookie(cookie_name) {
    var cookie_value = $.cookie(cookie_name);

    if (!cookie_value) {
        cookie_value = "vi";
        setCookie(cookie_name, cookie_value);
    }

    return cookie_value;
}

function setCookie(cookie_name, cookie_value) {
    $.cookie(cookie_name, cookie_value, { path: '/', expires: 365 });
}

function setLanguage(culture) {
    setCookie('Language', culture);
    window.location = '/';
}