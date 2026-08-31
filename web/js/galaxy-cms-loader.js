/**
 * GalaxyCMS - Dynamic Frontend Data Loader from Supabase
 * Tự động đồng bộ sản phẩm, giá bán, tỉnh thành, đại lý và cấu hình giá theo CMS
 */
(function (window) {
    const SUPABASE_BASE_URL = 'https://dwmpbrfjlufjkknknfsp.supabase.co/rest/v1';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3bXBicmZqbHVmamtrbmtuZnNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgwNzM3NzcsImV4cCI6MjEwMzY0OTc3N30.SWuEGWPRBLiC4J6txNha0AAP-IO_wzSfoIQ6sFpm5Kg';

    const headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': 'Bearer ' + SUPABASE_KEY,
        'Content-Type': 'application/json'
    };

    const GalaxyCMS = {
        // Lấy danh sách sản phẩm theo nhóm cấu hình trong CMS
        async getProducts(category) {
            try {
                let url = `${SUPABASE_BASE_URL}/san_pham?trang_thai=eq.Đang bán&order=created_at.desc`;
                if (category && category !== 'Tất cả sản phẩm') {
                    url += `&nhom_ten=eq.${encodeURIComponent(category)}`;
                }
                const res = await fetch(url, { headers });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.length > 0) return data;
                }
            } catch (e) {
                console.warn('GalaxyCMS: Không thể tải sản phẩm từ Supabase, dùng dữ liệu gốc', e);
            }
            return null;
        },

        // Lấy danh sách nhóm sản phẩm
        async getCategories() {
            try {
                const res = await fetch(`${SUPABASE_BASE_URL}/nhom_san_pham?order=thu_tu.asc`, { headers });
                if (res.ok) return await res.json();
            } catch (e) {}
            return null;
        },

        // Lấy 34 tỉnh thành chuẩn mới
        async getProvinces() {
            try {
                const res = await fetch(`${SUPABASE_BASE_URL}/tinh_thanh?kich_hoat=eq.true&order=thu_tu.asc`, { headers });
                if (res.ok) {
                    const list = await res.json();
                    if (list && list.length > 0) return list;
                }
            } catch (e) {}
            return null;
        },

        // Lấy danh sách đại lý
        async getDistributors(province) {
            try {
                let url = `${SUPABASE_BASE_URL}/dai_ly?order=created_at.desc`;
                if (province && province !== 'Tỉnh thành' && province !== 'Tất cả đại lý') {
                    url += `&tinh_thanh=eq.${encodeURIComponent(province)}`;
                }
                const res = await fetch(url, { headers });
                if (res.ok) return await res.json();
            } catch (e) {}
            return null;
        },

        // Lấy danh sách thợ sơn
        async getContractors(province) {
            try {
                let url = `${SUPABASE_BASE_URL}/tho_son?order=created_at.desc`;
                if (province && province !== 'Tỉnh thành' && province !== 'Tất cả thợ sơn') {
                    url += `&tinh_thanh=eq.${encodeURIComponent(province)}`;
                }
                const res = await fetch(url, { headers });
                if (res.ok) return await res.json();
            } catch (e) {}
            return null;
        },

        // Lấy cấu hình hệ thống (đơn giá m², % giảm giá)
        async getConfig(key, defaultValue) {
            try {
                const res = await fetch(`${SUPABASE_BASE_URL}/cau_hinh_he_thong?ma_cau_hinh=eq.${key}`, { headers });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.length > 0 && data[0].gia_tri) {
                        return data[0].gia_tri;
                    }
                }
            } catch (e) {}
            return defaultValue;
        },

        // Danh sách chương trình mặc định ban đầu
        DEFAULT_PROGRAMS: [
            { id: 'prog_1', tieu_de: 'Lucky Painter', duong_dan: 'lucky-painter.html', icon_url: 'web/frontend/images/multi-ico-12.png', ap_dung: true, thu_tu: 1 },
            { id: 'prog_2', tieu_de: 'Chương trình kiến trúc sư Galart', duong_dan: 'chuong-trinh-kien-truc-su-galart.html', icon_url: 'web/frontend/images/Galart_icon-01.png', ap_dung: true, thu_tu: 2 },
            { id: 'prog_3', tieu_de: 'Khuyến mãi 30% năm 2018', duong_dan: 'chuong-trinh-khuyen-mai.html', icon_url: 'web/frontend/images/multi-ico-2.png', ap_dung: true, thu_tu: 3 }
        ],

        // Lấy danh sách chương trình từ Supabase hoặc LocalStorage
        async getPrograms() {
            try {
                const res = await fetch(`${SUPABASE_BASE_URL}/cau_hinh_he_thong?ma_cau_hinh=eq.menu_chuong_trinh`, { headers });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.length > 0 && data[0].gia_tri) {
                        const parsed = JSON.parse(data[0].gia_tri);
                        if (Array.isArray(parsed) && parsed.length > 0) {
                            try { localStorage.setItem('galaxy_custom_programs', JSON.stringify(parsed)); } catch (e) {}
                            return parsed;
                        }
                    }
                }
            } catch (e) {}

            try {
                const cached = localStorage.getItem('galaxy_custom_programs');
                if (cached) return JSON.parse(cached);
            } catch (e) {}

            return this.DEFAULT_PROGRAMS;
        },

        // Đồng bộ động các chương trình ưu đãi hiển thị trên Menu theo CMS
        async initDynamicPrograms() {
            if (!window.$) return;
            var self = this;
            var programs = await self.getPrograms();
            if (!programs || !Array.isArray(programs)) return;

            function escapeText(str) {
                return String(str || '')
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;');
            }

            // 1. Đồng bộ Menu danh mục Sản phẩm trong top-header
            $('.list-nav-top').each(function () {
                var $ul = $(this);
                var $header = $ul.prev('h3');
                var isProductMenu = ($header.text() || '').trim().toLowerCase() === 'sản phẩm' ||
                                    $ul.find('a[href*="san-pham"]').length > 0 ||
                                    $ul.find('a[href*="dai-ly"]').length > 0;
                if (!isProductMenu) return;

                // Xác định tiền tố đường dẫn (nếu đang ở trang con cấp 1 như xu-huong-mau-sac/...)
                var prefix = '';
                var sampleA = $ul.find('a[href*="dai-ly"], a[href*="san-pham"]').first().attr('href') || '';
                if (sampleA.startsWith('../')) {
                    prefix = '../';
                } else if (sampleA.startsWith('/')) {
                    prefix = '/';
                }

                // Xóa bỏ các mục chương trình cũ tĩnh (Lucky Painter, Galart, Khuyến mãi hoặc mục CMS cũ)
                $ul.find('li').each(function () {
                    var $li = $(this);
                    var link = ($li.find('a').attr('href') || '').toLowerCase();
                    var text = ($li.text() || '').toLowerCase();
                    if ($li.attr('data-cms-program') === '1' ||
                        link.includes('lucky-painter') || 
                        link.includes('galart') || 
                        link.includes('khuyen-mai') ||
                        text.includes('lucky painter') ||
                        text.includes('galart') ||
                        text.includes('khuyến mãi') ||
                        text.includes('khuyen mai')) {
                        $li.remove();
                    }
                });

                // Render danh sách chương trình đang kích hoạt (ap_dung !== false)
                var activePrograms = programs
                    .filter(p => p.ap_dung !== false)
                    .sort((a, b) => (Number(a.thu_tu) || 1) - (Number(b.thu_tu) || 1));

                activePrograms.forEach(function (prog) {
                    var link = prog.duong_dan || '#';
                    if (prefix && !link.startsWith('http://') && !link.startsWith('https://') && !link.startsWith('/') && !link.startsWith('../')) {
                        link = prefix + link;
                    }
                    var icon = prog.icon_url || 'web/frontend/images/multi-ico-12.png';
                    if (prefix && !icon.startsWith('http://') && !icon.startsWith('https://') && !icon.startsWith('/') && !icon.startsWith('../')) {
                        icon = prefix + icon;
                    }

                    var extraStyle = '';
                    var imgStyle = '';
                    var titleLower = (prog.tieu_de || '').toLowerCase();
                    if (titleLower.includes('galart')) {
                        extraStyle = 'style="color: #46116d; font-weight: bold"';
                        imgStyle = 'style="width: 31px; height: 31px"';
                    } else if (titleLower.includes('khuyến mãi') || titleLower.includes('khuyen mai')) {
                        extraStyle = 'style="color: #46116d; font-weight: bold"';
                    }

                    var $newLi = $(`
                        <li data-cms-program="1">
                            <a href="${link}" ${extraStyle}>
                                <img src="${icon}" ${imgStyle} alt="" onerror="this.src='web/frontend/images/multi-ico-12.png'"> ${escapeText(prog.tieu_de || '')}
                            </a>
                        </li>
                    `);
                    $ul.append($newLi);
                });
            });

            // 2. Đồng bộ thanh icon ngang nav-main ở bottom-header (nếu có)
            var $nav = $('.nav-main');
            if ($nav.length > 0) {
                // Lưu danh sách items gốc ban đầu nếu chưa lưu
                if (!window._galaxyOriginalNavItems || window._galaxyOriginalNavItems.length === 0) {
                    var originalItems = [];
                    if ($nav.find('.owl-item:not(.cloned) .item').length > 0) {
                        $nav.find('.owl-item:not(.cloned) .item').each(function () {
                            originalItems.push($(this).clone());
                        });
                    } else {
                        $nav.find('.item').each(function () {
                            originalItems.push($(this).clone());
                        });
                    }
                    if (originalItems.length > 0) {
                        window._galaxyOriginalNavItems = originalItems;
                    }
                }

                if (window._galaxyOriginalNavItems && window._galaxyOriginalNavItems.length > 0) {
                    // Lấy danh sách các chương trình bị "Ngưng" (ap_dung === false)
                    var disabledPrograms = programs.filter(function (p) { return p.ap_dung === false; });

                    // Lọc các item được phép hiển thị
                    var activeNavItems = window._galaxyOriginalNavItems.filter(function ($el) {
                        var text = $el.text().toLowerCase();
                        var href = ($el.find('a').attr('href') || '').toLowerCase();
                        for (var i = 0; i < disabledPrograms.length; i++) {
                            var prog = disabledPrograms[i];
                            var pLink = (prog.duong_dan || '').toLowerCase().replace(/^\.?\.?\/?/, '').replace(/\.html$/, '');
                            var pTitle = (prog.tieu_de || '').toLowerCase();
                            if ((pLink && href.indexOf(pLink) !== -1) || 
                                (pTitle && (text.indexOf(pTitle) !== -1 || pTitle.indexOf(text.trim()) !== -1)) ||
                                (pTitle.indexOf('lucky painter') !== -1 && (text.indexOf('lucky painter') !== -1 || href.indexOf('lucky-painter') !== -1)) ||
                                (pTitle.indexOf('galart') !== -1 && (text.indexOf('galart') !== -1 || href.indexOf('galart') !== -1))) {
                                return false; // Bị ngưng -> loại bỏ
                            }
                        }
                        return true;
                    });

                    // Cập nhật lại thanh trượt Owl Carousel an toàn
                    if ($nav.data('owlCarousel') || $nav.hasClass('owl-loaded')) {
                        $nav.trigger('destroy.owl.carousel');
                        $nav.removeClass('owl-loaded owl-drag owl-carousel owl-theme');
                        $nav.empty();
                    } else {
                        $nav.empty();
                    }

                    activeNavItems.forEach(function ($item) {
                        $nav.append($item.clone());
                    });

                    if (typeof $nav.owlCarousel === 'function') {
                        $nav.owlCarousel({
                            autoWidth: true,
                            items: 6,
                            loop: true,
                            margin: 30,
                            nav: false
                        });
                    }
                }
            }
        },

        // Tự động đồng bộ sản phẩm theo nhóm CMS trên tất cả các trang
        initProductFilterCarousel() {
            if (!window.$) return;
            var $filters = $('.carousel-filter, #carousel-filter');
            var $productContainer = $('.load-product-list1');
            if ($filters.length === 0 || $productContainer.length === 0) return;

            if (window._galaxyProductFilterInitialized) return;
            window._galaxyProductFilterInitialized = true;

            var staticProductsCache = [];

            // Thu thập dữ liệu tĩnh có sẵn làm dự phòng
            $productContainer.find('#carousel-result-filter .item').each(function () {
                var $el = $(this);
                var img = $el.find('img').attr('src');
                var link = $el.find('a').attr('href') || '#';
                var badge = $el.find('.box-detail span').text().trim();
                var title = $el.find('.box-detail h3 a').text().trim();
                var desc = $el.find('.box-detail p').text().trim();
                var price = $el.find('.box-detail b').first().text().trim();
                var rating = $el.find('.box-detail b').last().text().trim();
                var cat = $el.attr('data-category') || '';

                if (!cat) {
                    var titleLower = title.toLowerCase();
                    var badgeLower = badge.toLowerCase();
                    if (badgeLower.includes('bột trét') || titleLower.includes('bột') || titleLower.includes('silk plaster') || titleLower === 'protector') {
                        cat = 'Bột trét tường';
                    } else if (badgeLower.includes('sơn lót') || titleLower.includes('sơn lót') || titleLower.includes('primer') || titleLower.includes('sealer') || titleLower.includes('lot')) {
                        cat = 'Sơn lót';
                    } else if (badgeLower.includes('chống thấm') || titleLower.includes('chống thấm') || titleLower.includes('proflex')) {
                        cat = 'SP chống thấm';
                    } else if (badgeLower.includes('tính năng') || badgeLower.includes('sơn sàn') || titleLower.includes('epoxy') || titleLower.includes('sơn dầu') || titleLower.includes('chống rỉ') || titleLower.includes('protector 2+')) {
                        cat = 'Sơn tính năng';
                    } else if (badgeLower.includes('ngoại thất') || titleLower.includes('ngoại thất') || titleLower.includes('pro 2+') || titleLower.includes('pro2+')) {
                        cat = 'Sơn ngoại thất';
                    } else if (badgeLower.includes('nội thất') || titleLower.includes('nội thất') || titleLower.includes('pro 1+') || titleLower.includes('pro1')) {
                        cat = 'Sơn nội thất';
                    }
                }

                if (title) {
                    staticProductsCache.push({
                        ten_san_pham: title,
                        nhom_ten: cat,
                        phan_khuc: badge,
                        mo_ta: desc,
                        gia_ban: price,
                        danh_gia: rating,
                        anh_url: img,
                        link_chi_tiet: link
                    });
                }
            });

            function renderCarousel(products) {
                if (!products || products.length === 0) return;

                var $container = $('.load-product-list1');
                var $oldCar = $container.find('.carousel-result-filter');
                if ($oldCar.data('owlCarousel') || $oldCar.data('owl.carousel')) {
                    try {
                        $oldCar.trigger('destroy.owl.carousel');
                    } catch (e) {}
                }

                var html = '';
                products.forEach(function (p) {
                    var priceFormatted = p.gia_ban ? (typeof p.gia_ban === 'number' ? Number(p.gia_ban).toLocaleString('vi-VN') + ' đ' : p.gia_ban) : 'Liên hệ';
                    if (!priceFormatted.includes('đ') && !priceFormatted.includes('Liên hệ')) priceFormatted += ' đ';
                    var detailLink = p.link_chi_tiet || '#';
                    var rating = p.danh_gia || p.quy_cach || '4.5';

                    // Xử lý huy hiệu phân khúc / loại sản phẩm chính xác
                    var nhom = (p.nhom_ten || '').trim();
                    var pk = (p.phan_khuc || '').trim();
                    var ten = (p.ten_san_pham || '').trim().toLowerCase();
                    var nhomLower = nhom.toLowerCase();
                    var badgeText = '';

                    // 1. Bột trét tường
                    if (nhomLower.includes('bột') || ten.includes('bột') || ten.includes('silk plaster') || ten === 'protector') {
                        if (!pk) {
                            badgeText = 'BỘT TRÉT CAO CẤP';
                        } else {
                            var pkUpper = pk.toUpperCase();
                            if (pkUpper.includes('BỘT')) {
                                badgeText = pkUpper;
                            } else {
                                badgeText = 'BỘT TRÉT ' + pkUpper;
                            }
                        }
                    }
                    // 2. Chống thấm
                    else if (nhomLower.includes('chống thấm') || ten.includes('chống thấm') || ten.includes('proflex')) {
                        if (!pk) {
                            badgeText = 'CHỐNG THẤM CAO CẤP';
                        } else {
                            var pkUpper = pk.toUpperCase();
                            if (pkUpper.includes('CHỐNG THẤM') || pkUpper.startsWith('SP')) {
                                badgeText = pkUpper;
                            } else {
                                badgeText = 'CHỐNG THẤM ' + pkUpper;
                            }
                        }
                    }
                    // 3. Sơn lót
                    else if (nhomLower.includes('sơn lót') || nhomLower.includes('son lot') || ten.includes('sơn lót') || ten.includes('lot') || ten.includes('primer') || ten.includes('sealer')) {
                        if (!pk) {
                            badgeText = 'SƠN LÓT CAO CẤP';
                        } else {
                            var pkUpper = pk.toUpperCase();
                            if (pkUpper.startsWith('SƠN LÓT')) {
                                badgeText = pkUpper;
                            } else if (pkUpper.startsWith('SƠN')) {
                                badgeText = pkUpper.replace(/^SƠN\s+/, 'SƠN LÓT ');
                            } else {
                                badgeText = 'SƠN LÓT ' + pkUpper;
                            }
                        }
                    }
                    // 4. Các loại sơn khác
                    else {
                        badgeText = (pk ? pk.toUpperCase() : (nhom ? nhom.toUpperCase() : 'SƠN GALAXY'));
                        if (!badgeText.startsWith('SƠN') && !badgeText.startsWith('BỘT') && !badgeText.startsWith('SP') && !badgeText.startsWith('CHỐNG')) {
                            badgeText = 'SƠN ' + badgeText;
                        }
                    }

                    html += '<div class="item" data-category="' + (p.nhom_ten || '') + '" data-segment="' + (p.phan_khuc || '') + '">' +
                            '  <div class="box-product">' +
                            '    <a href="' + detailLink + '"><img src="' + (p.anh_url || 'images/products/6641c950c774d.png') + '" alt="' + (p.ten_san_pham || '') + '"></a>' +
                            '    <div class="box-detail">' +
                            '      <a href="' + detailLink + '"><i class="fa fa-angle-right"></i></a>' +
                            '      <span>' + badgeText + '</span>' +
                            '      <h3><a href="' + detailLink + '">' + (p.ten_san_pham || '') + '</a></h3>' +
                            '      <p>' + (p.mo_ta || '') + '</p>' +
                            '      <b>' + priceFormatted + '</b>' +
                            '      <b style="float: right; font-size: 25px;">' + rating + '</b>' +
                            '    </div>' +
                            '  </div>' +
                            '</div>';
                });

                $container.html('<div id="carousel-result-filter" class="carousel-result-filter owl-carousel owl-theme">' + html + '</div>');

                $container.find('#carousel-result-filter').owlCarousel({
                    margin: 10,
                    items: 2,
                    autoWidth: true,
                    autoHeight: true,
                    loop: false,
                    nav: true,
                    dots: false,
                    navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>'],
                    responsive: {
                        0: { items: 1 },
                        600: { items: 2 },
                        1000: { items: 3 }
                    }
                });
            }

            function filterFallback(catName) {
                if (!catName || catName === 'Tất cả sản phẩm') return staticProductsCache;
                return staticProductsCache.filter(function (p) {
                    return p.nhom_ten === catName;
                });
            }

            function loadCategoryProducts(catName) {
                GalaxyCMS.getProducts(catName === 'Tất cả sản phẩm' ? null : catName).then(function (products) {
                    if (products && products.length > 0) {
                        renderCarousel(products);
                    } else {
                        renderCarousel(filterFallback(catName));
                    }
                }).catch(function () {
                    renderCarousel(filterFallback(catName));
                });
            }

            // Bắt sự kiện bấm vào từng nhóm sản phẩm
            $(document).off('click.galaxyCMS', '.product-list1');
            $(document).on('click.galaxyCMS', '.product-list1', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                var catName = $(this).text().trim();
                $('.carousel-filter .item').removeClass('active');
                $(this).closest('.item').addClass('active');
                loadCategoryProducts(catName);
                return false;
            });

            $(document).off('click.galaxyCMS', '.product-all-list1');
            $(document).on('click.galaxyCMS', '.product-all-list1', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                $('.carousel-filter .item').removeClass('active');
                $(this).closest('.item').addClass('active');
                loadCategoryProducts('Tất cả sản phẩm');
                return false;
            });

            // Tự động tải sản phẩm ban đầu từ CMS
            loadCategoryProducts('Tất cả sản phẩm');
        },

        // Đồng bộ và chuyển đổi bảng màu chi tiết động giữa các bộ sưu tập
        initColorGallery() {
            if (!window.$) return;
            var $colorList = $('.color-list');
            if ($colorList.length === 0) return;

            // Highlight tab bộ sưu tập tương ứng với trang hoặc tiêu đề hiện tại
            var currentTitle = $('.color-title').text().trim().toLowerCase();
            $colorList.each(function () {
                var $a = $(this);
                var id = $a.data('id');
                var name = $a.find('span').text().trim().toLowerCase();
                $a.attr('href', 'bang-mau-chi-tiet-' + id + '.html');
                if (name === currentTitle || window.location.pathname.includes('bang-mau-chi-tiet-' + id)) {
                    $('.slide-color .box-color').removeClass('slide-color-active active');
                    $a.addClass('slide-color-active');
                }
            });

            var pageCache = {};

            $(document).off('click.galaxyColor', '.color-list');
            $(document).on('click.galaxyColor', '.color-list', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                var $btn = $(this);
                var id = $btn.data('id');
                if (!id) return false;

                $('.slide-color .box-color').removeClass('slide-color-active active');
                $btn.addClass('slide-color-active');

                var targetUrl = 'bang-mau-chi-tiet-' + id + '.html';

                function applyData(html) {
                    var parser = new DOMParser();
                    var doc = parser.parseFromString(html, 'text/html');
                    var newTitle = doc.querySelector('.color-title') ? doc.querySelector('.color-title').textContent.trim() : '';
                    var newChangeColor = doc.querySelector('.change-color') ? doc.querySelector('.change-color').innerHTML : '';
                    var newColorBanner = doc.querySelector('.color-banner') ? doc.querySelector('.color-banner').innerHTML : '';

                    if (newTitle) {
                        $('.color-title').text(newTitle);
                    }

                    if (newChangeColor) {
                        var $changeColor = $('.change-color');
                        try {
                            $changeColor.find('.slide-shade-color').trigger('destroy.owl.carousel');
                        } catch (err) {}
                        $changeColor.html(newChangeColor);
                        $changeColor.find('.slide-shade-color').owlCarousel({
                            margin: 25,
                            loop: false,
                            autoWidth: true,
                            items: 4,
                            nav: true,
                            navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>']
                        });
                    }

                    if (newColorBanner) {
                        var $colorBanner = $('.color-banner');
                        try {
                            $colorBanner.find('.slideshow-image').trigger('destroy.owl.carousel');
                        } catch (err) {}
                        $colorBanner.html(newColorBanner);
                        $colorBanner.find('.slideshow-image').owlCarousel({
                            loop: false,
                            items: 1,
                            nav: true,
                            navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>']
                        });
                    }

                    if (window.history && window.history.pushState) {
                        window.history.pushState({ id: id }, '', targetUrl);
                    }

                    // Tự động cập nhật phòng mẫu tương tác theo bộ sưu tập mới
                    if (window.GalaxyCMS && window.GalaxyCMS.updateVisualizerCollection) {
                        window.GalaxyCMS.updateVisualizerCollection(newTitle, id);
                    }
                }

                if (pageCache[id]) {
                    applyData(pageCache[id]);
                } else {
                    fetch(targetUrl)
                        .then(function (res) { return res.text(); })
                        .then(function (html) {
                            pageCache[id] = html;
                            applyData(html);
                        })
                        .catch(function (err) {
                            window.location.href = targetUrl;
                        });
                }
                return false;
            });
        },

        // Hệ thống phòng phối màu tương tác thời gian thực (Room Visualizer)
        initInteractiveRoomVisualizer() {
            if (!window.$) return;
            var $shadeColor = $('.shade-color');
            if ($shadeColor.length === 0) return;
            if ($('#galaxy-room-visualizer').length > 0) return;

            var self = this;

            // Định nghĩa các không gian phòng mẫu
            var rooms = {
                living: {
                    id: 'living',
                    name: 'Phòng khách hiện đại',
                    icon: '🛋️',
                    img: 'images/products/5a27bec58c2ad.png',
                    wallClip: 'polygon(0% 0%, 100% 0%, 100% 75%, 84% 75%, 84% 60%, 27% 60%, 27% 75%, 0% 75%)',
                    blendMode: 'hue',
                    opacity: 0.94
                },
                bedroom: {
                    id: 'bedroom',
                    name: 'Phòng ngủ cao cấp',
                    icon: '🛏️',
                    img: 'upload/images/bedroom 7.jpg',
                    wallClip: 'polygon(8% 0%, 88% 0%, 88% 66%, 8% 66%)',
                    blendMode: 'multiply',
                    opacity: 0.86
                },
                study: {
                    id: 'study',
                    name: 'Phòng làm việc & đọc sách',
                    icon: '📚',
                    img: 'images/products/5a27bea4c9cb5.png',
                    wallClip: 'polygon(0% 0%, 100% 0%, 100% 64%, 0% 64%)',
                    blendMode: 'hue',
                    opacity: 0.94
                }
            };

            // Ảnh phối cảnh kiến trúc mẫu tương ứng cho 10 bộ sưu tập
            var themeShowcases = {
                18: ['images/products/5a27bec58c2ad.png', 'images/products/5a27bea4c9cb5.png', 'images/products/5a27bebc0bd58.png', 'images/products/5a27becdcc10f.png'],
                19: ['upload/images/c.jpg', 'images/products/5a27bec58c2ad.png'],
                20: ['images/products/5a27bebc0bd58.png', 'upload/images/xuc-cam-khong-ngo-chi-nho-nhung-phong-ngu-day-mau-sac_4493c0ad28.jpg'],
                21: ['images/products/5a27becdcc10f.png', 'upload/images/mau-trang.jpg'],
                22: ['upload/images/phong-ngu-thu-gian-voi-3-gam-mau-tuyet-dep.jpg', 'images/products/5a27bebc0bd58.png'],
                23: ['upload/images/bedroom 7.jpg', 'upload/images/xuc-cam-khong-ngo-chi-nho-nhung-phong-ngu-day-mau-sac_093995bd52.jpg'],
                24: ['images/products/5a27becdcc10f.png', 'upload/images/b.jpg'],
                25: ['upload/images/bedroom 7.jpg', 'upload/images/xuc-cam-khong-ngo-chi-nho-nhung-phong-ngu-day-mau-sac_093995bd52.jpg'],
                26: ['images/products/5a27bebc0bd58.png', 'images/products/5a27bec58c2ad.png'],
                27: ['images/products/59bf471c0bffd.png', 'images/products/5a27bec58c2ad.png']
            };

            var currentRoom = 'living';
            var currentMode = 'visualizer'; // 'visualizer' hoặc 'showcase'

            function rgbToHex(rgb) {
                if (!rgb) return '#A79B90';
                if (rgb.startsWith('#')) return rgb.toUpperCase();
                var m = rgb.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
                if (!m) return rgb;
                return ('#' + ((1 << 24) + (parseInt(m[1]) << 16) + (parseInt(m[2]) << 8) + parseInt(m[3])).toString(16).slice(1)).toUpperCase();
            }

            // Lấy màu mẫu ban đầu từ dải màu
            var initColor = {
                code: 'CG90041',
                hex: '#a79b90',
                collection: $('.color-title').text().trim() || 'Đương đại'
            };
            var $firstBox = $('.slide-shade-color .item:first .box-color:first');
            if ($firstBox.length > 0) {
                var bgCol = $firstBox.find('.color').css('background-color');
                var cd = $firstBox.find('span').text().trim();
                if (bgCol) initColor.hex = bgCol;
                if (cd) initColor.code = cd;
            }

            // Chèn mã CSS nhúng tinh tế cho Visualizer
            if (!$('#galaxy-visualizer-styles').length) {
                $('head').append(`
                <style id="galaxy-visualizer-styles">
                    .galaxy-room-visualizer-wrap {
                        margin: 25px 0 15px;
                        position: relative;
                        z-index: 5;
                    }
                    .visualizer-card {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid rgba(255, 255, 255, 0.16);
                        border-radius: 16px;
                        overflow: hidden;
                        box-shadow: 0 20px 45px rgba(0, 0, 0, 0.45);
                        backdrop-filter: blur(12px);
                        -webkit-backdrop-filter: blur(12px);
                    }
                    .visualizer-toolbar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 14px 22px;
                        background: rgba(30, 10, 50, 0.55);
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                        flex-wrap: wrap;
                        gap: 12px;
                    }
                    .visualizer-title-group {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }
                    .v-badge {
                        background: #ffcc00;
                        color: #331144;
                        font-size: 11px;
                        font-weight: 800;
                        padding: 3px 8px;
                        border-radius: 5px;
                        letter-spacing: 0.8px;
                        text-transform: uppercase;
                    }
                    .v-title {
                        margin: 0;
                        font-size: 17px;
                        color: #ffffff;
                        font-weight: 600;
                    }
                    .visualizer-controls {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        flex-wrap: wrap;
                    }
                    .v-btn-group {
                        display: flex;
                        background: rgba(255, 255, 255, 0.09);
                        border: 1px solid rgba(255, 255, 255, 0.18);
                        border-radius: 25px;
                        padding: 3px;
                        gap: 4px;
                    }
                    .v-btn {
                        background: transparent;
                        border: none;
                        color: #e0e0e0;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 13px;
                        cursor: pointer;
                        transition: all 0.25s ease;
                        font-family: inherit;
                        outline: none !important;
                    }
                    .v-btn:hover {
                        color: #ffffff;
                        background: rgba(255, 255, 255, 0.14);
                    }
                    .v-btn.active {
                        background: #ffcc00;
                        color: #331144;
                        font-weight: 700;
                        box-shadow: 0 2px 10px rgba(255, 204, 0, 0.35);
                    }
                    .visualizer-stage-container {
                        position: relative;
                        width: 100%;
                        overflow: hidden;
                    }
                    .v-interactive-stage {
                        position: relative;
                        width: 100%;
                        aspect-ratio: 1436 / 600;
                        background: #25093a;
                        overflow: hidden;
                    }
                    @media (max-width: 768px) {
                        .v-interactive-stage {
                            aspect-ratio: 16 / 10;
                        }
                    }
                    .v-base-img {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        display: block;
                        user-select: none;
                    }
                    .v-wall-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background-color: #a79b90;
                        mix-blend-mode: hue;
                        opacity: 0.94;
                        transition: background-color 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                        pointer-events: none;
                    }
                    .v-color-hud {
                        position: absolute;
                        bottom: 22px;
                        left: 22px;
                        background: rgba(18, 6, 32, 0.88);
                        border: 1px solid rgba(255, 255, 255, 0.25);
                        border-radius: 12px;
                        padding: 12px 18px;
                        display: flex;
                        align-items: center;
                        gap: 14px;
                        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.6);
                        backdrop-filter: blur(14px);
                        -webkit-backdrop-filter: blur(14px);
                        z-index: 10;
                    }
                    .v-hud-swatch {
                        width: 44px;
                        height: 44px;
                        border-radius: 10px;
                        border: 2px solid #ffffff;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
                        transition: background-color 0.4s ease;
                    }
                    .v-hud-details {
                        display: flex;
                        flex-direction: column;
                    }
                    .v-hud-label {
                        font-size: 11px;
                        color: #bbb;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }
                    .v-hud-code-row {
                        display: flex;
                        align-items: baseline;
                        gap: 8px;
                    }
                    .v-hud-code {
                        font-size: 18px;
                        font-weight: 800;
                        color: #ffffff;
                    }
                    .v-hud-hex {
                        font-size: 12px;
                        color: #ffcc00;
                        font-family: monospace;
                        font-weight: 600;
                    }
                    .v-hud-collection {
                        font-size: 12px;
                        color: #d1c4e9;
                    }
                    .v-hud-badge {
                        background: rgba(255, 204, 0, 0.15);
                        color: #ffcc00;
                        border: 1px solid rgba(255, 204, 0, 0.4);
                        padding: 4px 10px;
                        border-radius: 15px;
                        font-size: 11px;
                        font-weight: bold;
                        margin-left: 8px;
                    }
                    .v-hint-tooltip {
                        position: absolute;
                        top: 18px;
                        right: 18px;
                        background: rgba(0, 0, 0, 0.72);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        color: #ffffff;
                        padding: 8px 14px;
                        border-radius: 20px;
                        font-size: 12px;
                        backdrop-filter: blur(8px);
                        z-index: 10;
                        pointer-events: none;
                    }
                    .v-swatch-bar-wrap {
                        padding: 12px 22px;
                        background: rgba(15, 5, 26, 0.55);
                        border-top: 1px solid rgba(255, 255, 255, 0.08);
                        display: flex;
                        align-items: center;
                        gap: 14px;
                        overflow-x: auto;
                    }
                    .v-swatch-bar-title {
                        font-size: 13px;
                        font-weight: 600;
                        color: #ffcc00;
                        white-space: nowrap;
                    }
                    .v-swatch-bar {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }
                    .v-swatch-chip {
                        width: 36px;
                        height: 36px;
                        border-radius: 8px;
                        cursor: pointer;
                        border: 2px solid rgba(255, 255, 255, 0.3);
                        transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1), border-color 0.2s, box-shadow 0.2s;
                        flex-shrink: 0;
                    }
                    .v-swatch-chip:hover {
                        transform: scale(1.22);
                        border-color: #ffffff;
                        box-shadow: 0 4px 14px rgba(255, 255, 255, 0.4);
                    }
                    .v-swatch-chip.active {
                        transform: scale(1.25);
                        border-color: #ffcc00;
                        box-shadow: 0 0 15px #ffcc00;
                    }
                    .slide-shade-color .box-color.active-wall-color {
                        outline: 3px solid #ffcc00 !important;
                        box-shadow: 0 0 16px rgba(255, 204, 0, 0.85) !important;
                        transform: scale(1.06);
                    }
                </style>
                `);
            }

            // HTML của Visualizer Component
            var html = `
            <div id="galaxy-room-visualizer" class="galaxy-room-visualizer-wrap">
                <div class="container">
                    <div class="visualizer-card">
                        <div class="visualizer-toolbar">
                            <div class="visualizer-title-group">
                                <span class="v-badge">GALAXY VISUALIZER</span>
                                <h3 class="v-title">Sơn Thử Màu Tường Trực Quan</h3>
                            </div>
                            <div class="visualizer-controls">
                                <div class="v-btn-group">
                                    <button type="button" class="v-btn v-room-btn active" data-room="living">🛋️ Phòng khách</button>
                                    <button type="button" class="v-btn v-room-btn" data-room="bedroom">🛏️ Phòng ngủ</button>
                                    <button type="button" class="v-btn v-room-btn" data-room="study">📚 Phòng làm việc</button>
                                </div>
                                <div class="v-btn-group">
                                    <button type="button" class="v-btn v-mode-btn active" data-mode="visualizer">🎨 Sơn thử tương tác</button>
                                    <button type="button" class="v-btn v-mode-btn" data-mode="showcase">🖼️ Ảnh mẫu kiến trúc</button>
                                </div>
                            </div>
                        </div>

                        <div class="visualizer-stage-container">
                            <!-- Chế độ 1: Sơn thử tương tác thời gian thực -->
                            <div class="v-interactive-stage" id="v-interactive-stage">
                                <img class="v-base-img" id="v-base-img" src="${rooms.living.img}" alt="Phòng mẫu Galaxy">
                                <div class="v-wall-overlay" id="v-wall-overlay" style="background-color: ${initColor.hex}; clip-path: ${rooms.living.wallClip};"></div>
                                
                                <div class="v-color-hud" id="v-color-hud">
                                    <div class="v-hud-swatch-box">
                                        <div class="v-hud-swatch" id="v-hud-swatch" style="background-color: ${initColor.hex};"></div>
                                    </div>
                                    <div class="v-hud-details">
                                        <span class="v-hud-label">Màu đang sơn thử:</span>
                                        <div class="v-hud-code-row">
                                            <strong class="v-hud-code" id="v-hud-code">${initColor.code}</strong>
                                            <span class="v-hud-hex" id="v-hud-hex">${rgbToHex(initColor.hex)}</span>
                                        </div>
                                        <span class="v-hud-collection" id="v-hud-collection">Bộ sưu tập: ${initColor.collection}</span>
                                    </div>
                                    <div class="v-hud-badge">Thời gian thực</div>
                                </div>

                                <div class="v-hint-tooltip">
                                    💡 Click bất kỳ ô màu nào ở dải sắc độ phía trên để đổi màu tường phòng ngay lập tức
                                </div>
                            </div>
                        </div>

                        <div class="v-swatch-bar-wrap">
                            <div class="v-swatch-bar-title">Mã màu nổi bật:</div>
                            <div class="v-swatch-bar" id="v-quick-swatches"></div>
                        </div>
                    </div>
                </div>
            </div>
            `;

            // Chèn Visualizer vào ngay dưới .shade-color
            $shadeColor.after(html);

            // Hàm áp dụng màu lên tường phòng và HUD
            this.applyWallColor = function (hex, code) {
                $('#v-wall-overlay').css('background-color', hex);
                $('#v-hud-swatch').css('background-color', hex);
                $('#v-hud-code').text(code);
                $('#v-hud-hex').text(rgbToHex(hex));
                
                // Đồng bộ active chip trong quick swatches
                $('.v-swatch-chip').removeClass('active');
                $(`.v-swatch-chip[data-code="${code}"]`).addClass('active');
            };

            // Hàm cập nhật danh sách chip màu nhanh từ bảng sắc độ hiện tại
            this.refreshQuickSwatches = function () {
                var $bar = $('#v-quick-swatches');
                $bar.empty();
                var currentCol = $('.color-title').text().trim() || 'Đương đại';
                $('#v-hud-collection').text('Bộ sưu tập: ' + currentCol);

                var colorsFound = [];
                $('.slide-shade-color .box-color').each(function () {
                    var bg = $(this).find('.color').css('background-color');
                    var c = $(this).find('span').text().trim();
                    if (bg && c && !colorsFound.some(x => x.code === c)) {
                        colorsFound.push({ hex: bg, code: c });
                    }
                });

                colorsFound.slice(0, 16).forEach(function (col, idx) {
                    var $chip = $('<div class="v-swatch-chip" data-code="' + col.code + '" title="' + col.code + ' (' + rgbToHex(col.hex) + ')"></div>');
                    $chip.css('background-color', col.hex);
                    if (idx === 0) $chip.addClass('active');
                    $chip.on('click', function () {
                        $('.v-swatch-chip').removeClass('active');
                        $(this).addClass('active');
                        self.applyWallColor(col.hex, col.code);
                    });
                    $bar.append($chip);
                });

                // Tự động sơn màu đầu tiên nếu có
                if (colorsFound.length > 0) {
                    self.applyWallColor(colorsFound[0].hex, colorsFound[0].code);
                }
            };

            // Hàm gọi khi chuyển sang Bộ sưu tập khác
            this.updateVisualizerCollection = function (collectionTitle, collectionId) {
                $('#v-hud-collection').text('Bộ sưu tập: ' + collectionTitle);
                setTimeout(function () {
                    self.refreshQuickSwatches();
                }, 300);

                // Cập nhật bộ ảnh kiến trúc mẫu cho bộ sưu tập này
                if (collectionId && themeShowcases[collectionId]) {
                    var imgs = themeShowcases[collectionId];
                    var $car = $('.color-banner .slideshow-image');
                    if ($car.length > 0) {
                        try {
                            $car.trigger('destroy.owl.carousel');
                        } catch (err) {}
                        var imgHtml = imgs.map(src => `<div class="item"><img src="${src}" alt="${collectionTitle}"></div>`).join('');
                        $car.html(imgHtml);
                        $car.owlCarousel({
                            loop: false,
                            items: 1,
                            nav: true,
                            navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>']
                        });
                    }
                }
            };

            // Khởi tạo các chip màu nhanh ban đầu
            this.refreshQuickSwatches();

            // 1. Bắt sự kiện click chọn phòng (Phòng khách / Phòng ngủ / Phòng làm việc)
            $(document).off('click.galaxyRoom', '.v-room-btn');
            $(document).on('click.galaxyRoom', '.v-room-btn', function () {
                $('.v-room-btn').removeClass('active');
                $(this).addClass('active');
                var rKey = $(this).data('room');
                var rConfig = rooms[rKey];
                if (!rConfig) return;

                currentRoom = rKey;
                $('#v-base-img').attr('src', rConfig.img);
                $('#v-wall-overlay').css({
                    'clip-path': rConfig.wallClip,
                    'mix-blend-mode': rConfig.blendMode || 'hue',
                    'opacity': rConfig.opacity || 0.94
                });
            });

            // 2. Bắt sự kiện chuyển chế độ (Sơn thử tương tác vs Ảnh mẫu kiến trúc)
            $(document).off('click.galaxyMode', '.v-mode-btn');
            $(document).on('click.galaxyMode', '.v-mode-btn', function () {
                $('.v-mode-btn').removeClass('active');
                $(this).addClass('active');
                var mode = $(this).data('mode');
                currentMode = mode;

                if (mode === 'showcase') {
                    $('#v-interactive-stage').slideUp(300);
                    $('.color-banner').slideDown(300);
                    var bannerTop = $('.color-banner').offset() ? $('.color-banner').offset().top - 80 : 0;
                    if (bannerTop) $('html, body').animate({ scrollTop: bannerTop }, 400);
                } else {
                    $('#v-interactive-stage').slideDown(300);
                    $('.color-banner').slideUp(300);
                }
            });

            // 3. Bắt sự kiện click vào bất kỳ ô mã màu nào trong bảng Sắc độ
            $(document).off('click.galaxyWallTint', '.slide-shade-color .box-color');
            $(document).on('click.galaxyWallTint', '.slide-shade-color .box-color', function (e) {
                e.preventDefault();
                var $box = $(this);
                var hex = $box.find('.color').css('background-color');
                var code = $box.find('span').text().trim();
                if (!hex || !code) return;

                $('.slide-shade-color .box-color').removeClass('active-wall-color');
                $box.addClass('active-wall-color');

                // Nếu đang ở chế độ ảnh kiến trúc, chuyển ngay sang chế độ sơn thử tương tác
                if (currentMode === 'showcase') {
                    $('.v-mode-btn[data-mode="visualizer"]').click();
                }

                self.applyWallColor(hex, code);
            });
        }
    };

    window.GalaxyCMS = GalaxyCMS;

    // Tự động khởi chạy an toàn và tức thì trên mọi trang
    function autoInit() {
        if (typeof $ !== 'undefined' && window.GalaxyCMS) {
            GalaxyCMS.initProductFilterCarousel();
            GalaxyCMS.initColorGallery();
            GalaxyCMS.initInteractiveRoomVisualizer();
            GalaxyCMS.initDynamicPrograms();
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', autoInit);
    } else {
        autoInit();
    }

    if (typeof $ !== 'undefined') {
        $(document).ready(autoInit);
    }
    window.addEventListener('load', autoInit);
})(window);

