-- ==============================================================================
-- LỆNH BỔ SUNG CỘT "MÃ HÀNG" CHO BẢNG SẢN PHẨM TRÊN SUPABASE
-- Hướng dẫn: Mở Supabase -> Vào mục SQL Editor -> Dán lệnh dưới đây và nhấn RUN.
-- ==============================================================================

-- 1. Bổ sung cột ma_hang nếu chưa tồn tại
ALTER TABLE IF EXISTS public.san_pham 
ADD COLUMN IF NOT EXISTS ma_hang TEXT;

-- 2. Đảm bảo tắt RLS để trang quản trị admin.html có toàn quyền Thêm / Sửa / Nhập Excel
ALTER TABLE IF EXISTS public.san_pham DISABLE ROW LEVEL SECURITY;

-- 3. Cập nhật mã hàng mẫu cho một số sản phẩm hiện có (tùy chọn)
UPDATE public.san_pham SET ma_hang = 'GLX-PRO1-01' WHERE ten_san_pham ILIKE '%Pro 1: Siêu bóng%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-PRO1-02' WHERE ten_san_pham ILIKE '%Pro 1: Bóng ngọc trai%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-PRO2-01' WHERE ten_san_pham ILIKE '%Pro 2: Siêu bóng co giãn%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-PRO2-02' WHERE ten_san_pham ILIKE '%Pro 2: Kháng muối%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-PRO2-03' WHERE ten_san_pham ILIKE '%Pro 2: Bóng Hoàn Mỹ%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-CT-01' WHERE ten_san_pham ILIKE '%Siêu chống thấm%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-LOT-01' WHERE ten_san_pham ILIKE '%Sơn lót%' AND ma_hang IS NULL;
UPDATE public.san_pham SET ma_hang = 'GLX-BOT-01' WHERE ten_san_pham ILIKE '%SILK PLASTER%' AND ma_hang IS NULL;
