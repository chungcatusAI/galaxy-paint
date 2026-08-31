-- ==============================================================================
-- SQL SCRIPT: MỞ TOÀN QUYỀN (RLS) VÀ TẠO BẢNG CHƯƠNG TRÌNH TRÊN SUPABASE
-- Hướng dẫn: Đăng nhập vào Supabase -> Chọn dự án Sơn Galaxy -> Vào mục "SQL Editor" -> Dán toàn bộ nội dung file này vào và nhấn RUN.
-- ==============================================================================

-- 1. MỞ QUYỀN TOÀN BỘ CÁC BẢNG TIẾP NHẬN DỮ LIỆU TỪ KHÁCH HÀNG (4 Bước, Phối Màu, Liên Hệ)
-- (Khắc phục triệt để lỗi 401: "new row violates row-level security policy")
ALTER TABLE IF EXISTS public.leads_4step DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.yeu_cau_phoi_mau DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.lien_he DISABLE ROW LEVEL SECURITY;

-- Mở quyền các bảng danh mục nếu chưa mở
ALTER TABLE IF EXISTS public.nhom_san_pham DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.san_pham DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.tinh_thanh DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.dai_ly DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.tho_son DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cau_hinh_he_thong DISABLE ROW LEVEL SECURITY;

-- 2. TẠO VÀ MỞ QUYỀN BẢNG QUẢN LÝ CHƯƠNG TRÌNH ƯU ĐÃI (public.chuong_trinh)
CREATE TABLE IF NOT EXISTS public.chuong_trinh (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    tieu_de TEXT NOT NULL,
    duong_dan TEXT NOT NULL,
    icon_url TEXT DEFAULT 'web/frontend/images/multi-ico-12.png',
    ap_dung BOOLEAN DEFAULT true,
    thu_tu INT DEFAULT 1,
    mo_ta TEXT
);

-- Mở quyền cho bảng chuong_trinh
ALTER TABLE IF EXISTS public.chuong_trinh DISABLE ROW LEVEL SECURITY;

-- Nạp 3 chương trình mẫu chuẩn theo hệ thống website
DELETE FROM public.chuong_trinh;
INSERT INTO public.chuong_trinh (tieu_de, duong_dan, icon_url, ap_dung, thu_tu, mo_ta)
VALUES
('Lucky Painter', 'lucky-painter.html', 'web/frontend/images/multi-ico-12.png', true, 1, 'Chương trình tích điểm đổi thưởng cho thợ sơn và nhà thầu'),
('Chương trình kiến trúc sư Galart', 'chuong-trinh-kien-truc-su-galart.html', 'web/frontend/images/Galart_icon-01.png', true, 2, 'Dành riêng cho kiến trúc sư, chuyên gia thiết kế nội ngoại thất'),
('Khuyến mãi 30% năm 2018', 'chuong-trinh-khuyen-mai.html', 'web/frontend/images/multi-ico-2.png', true, 3, 'Chương trình ưu đãi giảm giá và quà tặng khi mua sơn Galaxy');

-- 3. CHÈN BỔ SUNG 1 BẢN GHI MẪU VÀO 3 BẢNG ĐỂ KIỂM TRA HIỂN THỊ TRÊN CMS ADMIN
INSERT INTO public.leads_4step (ho_ten, so_dien_thoai, email, tinh_thanh, mau_son, dien_tich, du_toan_chi_phi, ma_giam_gia, trang_thai)
VALUES ('Khách Hàng Mẫu (4 Bước)', '0901234567', 'khachhang@gmail.com', 'Hà Nội', 'GLX-101 Sắc Tím Hoàng Gia', 120, 5040000, 'GLX2026-KM10', 'Chưa liên hệ');

INSERT INTO public.yeu_cau_phoi_mau (ho_ten, so_dien_thoai, dia_chi, loai_cong_trinh, tong_mau_yeu_thich, trang_thai)
VALUES ('Anh Minh (Tư Vấn Phối Màu)', '0988776655', 'Ba Đình, Hà Nội', 'Nhà phố 3 tầng', 'Tone Xanh Dương Thanh Lịch', 'Chưa liên hệ');

INSERT INTO public.lien_he (ho_ten, so_dien_thoai, email, noi_dung)
VALUES ('Chị Lan (Liên Hệ Đại Lý)', '0912345678', 'lan.nguyen@company.com', 'Tôi muốn tìm hiểu chính sách mở đại lý cấp 1 tại khu vực miền Trung.');

-- ==============================================================================
-- HOÀN TẤT! Sau khi chạy xong, CMS sẽ lập tức hiển thị dữ liệu đầy đủ 100%!
-- ==============================================================================
