-- ============================================================
-- SQL SCRIPT: Tạo bảng quản lý chương trình ưu đãi website Sơn Galaxy
-- Chạy script này trên Supabase SQL Editor nếu muốn dùng bảng độc lập
-- ============================================================

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

-- Cho phép truy cập dữ liệu công khai (Anon read)
ALTER TABLE public.chuong_trinh ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Cho phép đọc chương trình công khai" 
ON public.chuong_trinh FOR SELECT USING (true);

CREATE POLICY "Cho phép quản trị thêm sửa xóa chương trình" 
ON public.chuong_trinh FOR ALL USING (true);

-- Nạp 3 chương trình mẫu chuẩn theo hệ thống
INSERT INTO public.chuong_trinh (tieu_de, duong_dan, icon_url, ap_dung, thu_tu, mo_ta)
VALUES
('Lucky Painter', 'lucky-painter.html', 'web/frontend/images/multi-ico-12.png', true, 1, 'Chương trình tích điểm đổi thưởng cho thợ sơn và nhà thầu'),
('Chương trình kiến trúc sư Galart', 'chuong-trinh-kien-truc-su-galart.html', 'web/frontend/images/Galart_icon-01.png', true, 2, 'Dành riêng cho kiến trúc sư, chuyên gia thiết kế nội ngoại thất'),
('Khuyến mãi 30% năm 2018', 'chuong-trinh-khuyen-mai.html', 'web/frontend/images/multi-ico-2.png', true, 3, 'Chương trình ưu đãi giảm giá và quà tặng khi mua sơn Galaxy');
