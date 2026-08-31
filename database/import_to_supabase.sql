-- ==============================================================================
-- LỆNH NẠP BỔ SUNG: SẢN PHẨM, GIÁ BÁN, NHÓM SẢN PHẨM & 34 TỈNH THÀNH
-- (Dán lệnh này vào SQL Editor trên Supabase và bấm RUN)
-- ==============================================================================

-- 1. MỞ QUYỀN TOÀN BỘ CÁC BẢNG ĐỂ TRANG ADMIN CÓ THỂ SỬA TRỰC TIẾP
alter table public.nhom_san_pham disable row level security;
alter table public.san_pham disable row level security;
alter table public.tinh_thanh disable row level security;
alter table public.dai_ly disable row level security;
alter table public.tho_son disable row level security;
alter table public.cau_hinh_he_thong disable row level security;

-- 2. NẠP CẤU HÌNH ĐƠN GIÁ & HỆ THỐNG
delete from public.cau_hinh_he_thong where ma_cau_hinh in ('don_gia_m2', 'phan_tram_giam_gia', 'hotline');
insert into public.cau_hinh_he_thong (ma_cau_hinh, ten_cau_hinh, gia_tri, mo_ta) values
('don_gia_m2', 'Đơn giá dự toán sơn (đ/m²)', '42000', 'Đơn giá tính toán lượng sơn cho phần mềm tính sơn và 4 bước sơn nhà'),
('phan_tram_giam_gia', 'Tỷ lệ mã giảm giá (%)', '15', 'Tỷ lệ phần trăm giảm giá hiển thị trên mã ưu đãi khách nhận được'),
('hotline', 'Hotline hỗ trợ', '1900 636 186', 'Số tổng đài tư vấn sơn toàn quốc');

-- 3. NẠP 6 NHÓM SẢN PHẨM
truncate table public.nhom_san_pham;
insert into public.nhom_san_pham (ten_nhom, slug, thu_tu, mo_ta) values
('Sơn ngoại thất', 'son-ngoai-that', 1, 'Dòng sơn bảo vệ ngoài trời chống thấm, kháng tia UV'),
('Sơn nội thất', 'son-noi-that', 2, 'Dòng sơn trong nhà lau chùi hiệu quả, kháng khuẩn'),
('SP chống thấm', 'sp-chong-tham', 3, 'Các sản phẩm chống thấm tường đứng, sàn'),
('Sơn tính năng', 'son-tinh-nang', 4, 'Sơn hiệu ứng ánh kim, siêu bóng'),
('Sơn lót', 'son-lot', 5, 'Sơn lót kháng kiềm, tăng độ bám dính'),
('Bột trét tường', 'bot-tret-tuong', 6, 'Bột bả làm phẳng bề mặt tường nội ngoại thất');

-- 4. TẠO & NẠP BẢNG DANH MỤC MIỀN (KHU VỰC)
create table if not exists public.danh_muc_mien (
    id text primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    ma_mien text unique not null,
    ten_mien text not null,
    thu_tu integer default 1,
    mo_ta text
);
alter table public.danh_muc_mien disable row level security;

delete from public.danh_muc_mien;
insert into public.danh_muc_mien (id, ma_mien, ten_mien, thu_tu, mo_ta) values
('mien_bac', 'BAC', 'Miền Bắc', 1, '15 tỉnh thành Bắc Bộ'),
('mien_trung', 'TRUNG', 'Miền Trung', 2, '11 tỉnh thành Trung Bộ & Tây Nguyên'),
('mien_nam', 'NAM', 'Miền Nam', 3, '8 tỉnh thành Nam Bộ');

-- 5. NẠP 34 TỈNH THÀNH THEO THỨ TỰ TỪ BẮC ĐỔ DẦN VÀO NAM (1 - 34)
truncate table public.tinh_thanh;
insert into public.tinh_thanh (ten_tinh, mien, ghi_chu_sap_nhap, thu_tu) values
-- MIỀN BẮC (15 tỉnh/thành)
('TỈNH ĐIỆN BIÊN', 'Miền Bắc', 'Giữ nguyên', 1),
('TỈNH LAI CHÂU', 'Miền Bắc', 'Giữ nguyên', 2),
('TỈNH LÀO CAI', 'Miền Bắc', 'Sáp nhập Lào Cai + Yên Bái', 3),
('TỈNH TUYÊN QUANG', 'Miền Bắc', 'Sáp nhập Tuyên Quang + Hà Giang', 4),
('TỈNH CAO BẰNG', 'Miền Bắc', 'Giữ nguyên', 5),
('TỈNH LẠNG SƠN', 'Miền Bắc', 'Giữ nguyên', 6),
('TỈNH SƠN LA', 'Miền Bắc', 'Giữ nguyên', 7),
('TỈNH THÁI NGUYÊN', 'Miền Bắc', 'Sáp nhập Thái Nguyên + Bắc Kạn', 8),
('TỈNH PHÚ THỌ', 'Miền Bắc', 'Sáp nhập Phú Thọ + Vĩnh Phúc + Hòa Bình', 9),
('TỈNH QUẢNG NINH', 'Miền Bắc', 'Giữ nguyên', 10),
('TỈNH BẮC NINH', 'Miền Bắc', 'Sáp nhập Bắc Ninh + Bắc Giang', 11),
('TP. HÀ NỘI', 'Miền Bắc', 'Thủ đô Hà Nội', 12),
('TP. HẢI PHÒNG', 'Miền Bắc', 'Sáp nhập Hải Phòng + Hải Dương', 13),
('TỈNH HƯNG YÊN', 'Miền Bắc', 'Sáp nhập Hưng Yên + Thái Bình', 14),
('TỈNH NINH BÌNH', 'Miền Bắc', 'Sáp nhập Ninh Bình + Hà Nam + Nam Định', 15),

-- MIỀN TRUNG (11 tỉnh/thành)
('TỈNH THANH HÓA', 'Miền Trung', 'Giữ nguyên', 16),
('TỈNH NGHỆ AN', 'Miền Trung', 'Giữ nguyên', 17),
('TỈNH HÀ TĨNH', 'Miền Trung', 'Giữ nguyên', 18),
('TỈNH QUẢNG TRỊ', 'Miền Trung', 'Sáp nhập Quảng Trị + Quảng Bình', 19),
('TP. HUẾ', 'Miền Trung', 'Thành lập TP trực thuộc TW từ Thừa Thiên Huế', 20),
('TP. ĐÀ NẴNG', 'Miền Trung', 'Sáp nhập Đà Nẵng + Quảng Nam', 21),
('TỈNH QUẢNG NGÃI', 'Miền Trung', 'Sáp nhập Quảng Ngãi + Kon Tum', 22),
('TỈNH GIA LAI', 'Miền Trung', 'Sáp nhập Gia Lai + Bình Định', 23),
('TỈNH ĐẮK LẮK', 'Miền Trung', 'Sáp nhập Đắk Lắk + Phú Yên', 24),
('TỈNH KHÁNH HÒA', 'Miền Trung', 'Sáp nhập Khánh Hòa + Ninh Thuận', 25),
('TỈNH LÂM ĐỒNG', 'Miền Trung', 'Sáp nhập Lâm Đồng + Đắk Nông + Bình Thuận', 26),

-- MIỀN NAM (8 tỉnh/thành)
('TỈNH TÂY NINH', 'Miền Nam', 'Sáp nhập Tây Ninh + Long An', 27),
('TỈNH ĐỒNG NAI', 'Miền Nam', 'Sáp nhập Đồng Nai + Bình Phước', 28),
('TP. HỒ CHÍ MINH', 'Miền Nam', 'Sáp nhập TP.HCM + Bình Dương + Bà Rịa Vũng Tàu', 29),
('TỈNH ĐỒNG THÁP', 'Miền Nam', 'Sáp nhập Đồng Tháp + Tiền Giang', 30),
('TỈNH VĨNH LONG', 'Miền Nam', 'Sáp nhập Vĩnh Long + Bến Tre + Trà Vinh', 31),
('TỈNH AN GIANG', 'Miền Nam', 'Sáp nhập An Giang + Kiên Giang', 32),
('TP. CẦN THƠ', 'Miền Nam', 'Sáp nhập Cần Thơ + Sóc Trăng + Hậu Giang', 33),
('TỈNH CÀ MAU', 'Miền Nam', 'Sáp nhập Cà Mau + Bạc Liêu', 34);

-- 6. NẠP TOÀN BỘ 47 SẢN PHẨM & GIÁ BÁN THỰC TẾ
truncate table public.san_pham;
insert into public.san_pham (ten_san_pham, nhom_ten, phan_khuc, gia_ban, quy_cach, mo_ta, anh_url) values
('Sơn nội thất Pro1: Mịn lụa là', 'Sơn nội thất', 'SƠN KINH TẾ', 1428000, '4.5', 'Sơn nội thất láng mịn cho không gian sống của bạn', 'images/products/6641c950c774d.png'),
('Sơn nội thất Pro 1: Siêu bóng tự làm sạch', 'Sơn nội thất', 'SƠN SIÊU CAO CẤP', 2214000, '4.5', 'Tự làm sạch, kháng khuẩn với công nghệ Nano Silver, siêu sáng bóng hoàn mỹ, sắc màu rạng rỡ, bền màu tối đa, che lấp khe nứt nhỏ, phù hợp kẻ vẽ hoa văn, công trình tâm linh, phòng sạch chuyên dụng, công trình cao cấp, biệt tự lâu đài.', 'images/products/6641c9c7be9b3.png'),
('Sơn nội thất Pro 1: Siêu bóng', 'Sơn nội thất', 'SƠN CAO CẤP', 5962000, '15 lít', 'Siêu bóng đẳng cấp, sắc màu tinh tế và hiện đại, bền màu lên đến 10 năm.', 'images/products/6641c9e0aae12.png'),
('Sơn nội thất Pro 1: Bóng ngọc trai', 'Sơn nội thất', 'SƠN CAO CẤP', 4815000, '15 lít', 'Bóng ngọc trai sang trọng, sắc màu rạng rỡ & bền màu, ngăn hình thành vết ố bẩn, dễ lau chùi.', 'images/products/6641ca0cd2a06.png'),
('Sơn nội thất: Lau chùi vượt trội', 'Sơn nội thất', 'SƠN TRUNG CAO', 2877000, '15 lít', 'Dễ lau chùi các vết bẩn, bề mặt láng mịn, chống nấm mốc.', 'images/products/6641c79d98ef4.png'),
('Sơn nội thất Pro 1: Siêu trắng trần', 'Sơn nội thất', 'SƠN TRUNG CAO', 2769000, '17 lít', 'Màu trắng sáng tự nhiên đẳng cấp, sắc trắng lâu bền, không bám bụi.', 'images/products/6641cb8df0287.png'),
('Sơn ngoại thất Pro 2: Siêu bóng co giãn', 'Sơn ngoại thất', 'SƠN SIÊU CAO CẤP', 3072000, '4.5', 'Sơn ngoại thất siêu cao cấp với tính năng co giãn chống rạn nứt cùng độ siêu sáng bóng tạo một vẻ đẹp hoàn hảo cho ngôi nhà bạn.', 'images/products/6641c995554b9.png'),
('PRO2+ SALT PROOF', 'Sơn ngoại thất', 'Sơn ngoại thất siêu cao cấp', 2619000, '5 lít', 'CHỐNG MUỐI HOÁ, BỀN THỜI TIẾT VƯỢT TRỘI', 'images/products/619200d1202c7.png'),
('Sơn ngoại thất Pro 2: Bóng Hoàn Mỹ', 'Sơn ngoại thất', 'SƠN CAO CẤP', 2405000, '4.5', 'Màng sơn bóng hoàn mỹ, đanh cứng cho khả năng chịu biến thiên thời tiết với biên độ cao gấp 2 lần – chống bám bụi – chống kiềm hóa – chống nấm mốc.', 'images/products/6641c29b2a9e6.png'),
('Sơn ngoại thất Pro 2: Kháng muối kháng kiềm', 'Sơn ngoại thất', 'SƠN SIÊU CAO CẤP', 3072000, '4.5', ': Siêu sáng bóng, chống muối hóa, bền thời tiết vượt trội, chống bám bẩn, chống UV, chống thấm, chống nấm mốc, chống kiềm', 'images/products/6641c9b0e359a.png'),
('Sơn ngoại thất Pro 2: Bóng ngọc trai', 'Sơn ngoại thất', 'SƠN CAO CẤP', 5650000, '15 lít', 'Màng sơn bóng ngọc trai, chống nắng hiệu quả, chống nấm mốc, chống thấm, bóng, bền màu.', 'images/products/6641c9f65da1d.png'),
('Sơn ngoại thất Pro 2: Mịn màng hiệu quả', 'Sơn ngoại thất', 'SƠN TRUNG CẤP', 1800000, '15 lít', 'Màng sơn mịn màng, độ bám dính cao, chống rêu mốc, ít tiêu hao', 'images/products/6647329dc5b7e.png'),
('Sơn ngoại thất Pro 2: Mịn màng tươi sáng', 'Sơn ngoại thất', 'Sơn ngoại thất Pro2', 580000, '4.5', '', 'images/products/6614e91d02333.png'),
('Sơn Pro: Siêu chống thấm màu', 'Sơn ngoại thất', 'SƠN CHỐNG THẤM', 4048000, '20 kg', 'Công nghệ mới với nhự PUD đặc biệt cao cấp đàn hồi tới 1.000%, tối đa hóa chống thấm & dễ thi công. Đặc biệt màu sắc rực rỡ & phong phú như sơn phủ ngoại thất.', 'images/products/66473415ae369.png'),
('Sơn Pro: Siêu chống thấm đa năng', 'SP chống thấm', 'SƠN CHỐNG THẤM', 4855000, '20 kg', 'Là sự kết hợp hoàn hảo kỹ thuật chống thấm thành phần sơn và xi măng. Khả năng chống thấm gấp 10 lần. Bề mặt rắn rỏi, hiệu ứng lá sen.', 'images/products/6647368c8f340.png'),
('Chống thấm Pro: Chống thấm vượt trội', 'SP chống thấm', 'SƠN CHỐNG THẤM', 5288889, '20 kg', 'Công nghệ mới với nhũ tương cao su Polybutadiene + nhựa Silicone đàn hồi cao 2.000%, không độc hại, kết dính tối đa.', 'images/products/66473799839f5.png'),
('Sơn lót ngoại thất Pro2: Chống kiềm hiệu quả', 'Sơn ngoại thất', 'Sơn lót Ngoại thất Pro2', 920000, '5', 'Sơn Sơn lót ngoại thất hống kiềm, tăng cường độ phủ cho sơn màu.', 'images/products/6614e7276ffa1.png'),
('Sơn lót nội thất Pro1: Chống kiềm hiệu quả', 'Sơn lót', 'Sơn lót nội thất Pro1', 585000, '5', 'Sơn lót nội thất chống kiềm hiệu quả,  tăng cường độ phủ cho sơn màu.', 'images/products/6614e867b5ee4.png'),
('PRO 2+ BẢO VỆ HOÀN HẢO', 'Sơn ngoại thất', 'Sơn ngoại thất siêu cao cấp', 2619000, '5 lít', 'CO GIÃN CHỐNG RẠN NỨT VƯỢT TRỘI', 'images/products/619200ffb24da.png'),
('GLITTER BỀN THỜI TIẾT VƯỢT TRỘI', 'Sơn ngoại thất', 'Sơn ngoại thất cao cấp', 2163000, '5 lít', 'BỀN THỜI TIẾT X 2', 'images/products/61920151dce41.png'),
('LANSHINE CHỐNG UV', 'Sơn ngoại thất', 'Sơn ngoại thất cao cấp', 1748000, '5 lít', 'CHỐNG UV, GIẢM NHIỆT', 'images/products/619201b607ca8.png'),
('PRO 1+ HOÀN MỸ', 'Sơn nội thất', 'Sơn nội thất siêu cao cấp', 2016000, '5 lít', 'KHÁNG KHUẨN VỚI CÔNG NGHỆ NANO SILVER', 'images/products/619201f55257c.png'),
('GLITE TINH TẾ & HIỆN ĐẠI', 'Sơn nội thất', 'Sơn nội thất cao cấp', 1776000, '5 lít', 'BÓNG ĐẲNG CẤP VÀ TINH TẾ', 'images/products/6270850f64df1.png'),
('PRO2+ SALT PROOF PRIMER', 'Sơn ngoại thất', 'Sơn lót ngoại thất siêu cấp', 1380000, '5 lít', 'CHỐNG MUỐI HOÁ, CHỐNG KIỀM VƯỢT TRỘI', 'images/products/619202721aca6.png'),
('LANMYA BÓNG NGỌC TRAI', 'Sơn nội thất', 'Sơn nội thất cao cấp', 1429000, '5 lít', 'BÓNG NGỌC TRAI SANG TRỌNG', 'images/products/627085621c7a5.png'),
('LAX AMOR BỀN ĐẸP', 'Sơn ngoại thất', 'Sơn ngoại thất', 1024000, '4.5 lít', 'ĐỘ BÁM DÍNH CAO, CHỐNG NẤM MỐC', 'images/products/627085b983aff.png'),
('KLENTER LAU CHÙI VƯỢT TRỘI NEW', 'Sơn nội thất', 'Sơn nội thất', 891000, '4.5 lít', 'BỀ MẶT LÁNG MỊN, RẮN RỎI, DỄ LAU CHÙI', 'images/products/6192035778584.png'),
('CEILPRO SIÊU TRẮNG SÁNG', 'Sơn nội thất', 'Sơn nội thất', 754000, '4.5 lít', 'MÀU TRẮNG SÁNG TỰ NHIÊN, ĐẲNG CẤP, KHÔNG BÁM BỤI', 'images/products/627085f7102be.png'),
('LAX MATIC LÁNG MỊN', 'Sơn nội thất', 'Sơn nội thất', 517000, '4.5 lít', 'BỀ MẶT LÁNG MỊN, MÀU SẮC TƯƠI SÁNG', 'images/products/62708622cfdee.png'),
('GJC HIỆU QUẢ', 'Sơn nội thất', 'Sơn nội thất', 426000, '4.5 lít', 'CHỐNG NẤM MỐC, DỄ THI CÔNG', 'images/products/619204042fdbb.png'),
('PRO+ SIÊU CHỐNG THẤM MÀU', 'SP chống thấm', 'Chống thấm tường đứng', 1295000, '5 kg', 'CHỐNG THẤM TỐI ƯU VÀ DỄ THI CÔNG', 'images/products/62708667f2c44.png'),
('PRO+ CHỐNG THẤM ĐA NĂNG', 'SP chống thấm', 'Chống thấm 2 thành phần', 1133000, '5 kg', 'BỀ MẶT RẮN RỎI, HIỆU ỨNG LÁ SEN', 'images/products/627086aaaacec.png'),
('PROFLEX - CHỐNG THẤM VƯỢT TRỘI', 'SP chống thấm', 'Chống thấm sàn', 0, 'Thùng 18L', 'ĐỘ ĐÀN HỒI CAO 2000% - CHỐNG THẤM TỐI ĐA', 'images/products/5d5a223ca0cae.png'),
('PROTECTOR 3+', 'Sơn nội thất', 'Sơn siêu bóng vượt trội', 1325000, '5 lít', 'LỚP SƠN TRONG SUỐT VƯƠNG GIẢ, CHỊU VA ĐẬP', 'images/products/627086f6d2c67.png'),
('PROTECTOR 2+', 'Sơn tính năng', 'Sơn nhũ ánh kim', 2110000, '5 lít', 'SƠN SÁNG BÓNG CAO CẤP, HIỆU ỨNG LÁ SEN', 'images/products/6270871cf3da1.png'),
('PROFLEX', 'Sơn nội thất', 'Vữa rót không co ngót', 84000, '5 kg', 'ĐỘ CHẢY TUYỆT HẢO, CƯỜNG ĐỘ NÉN CAO', 'images/products/62708780dc86d.png'),
('EPOXY EXP­-LINE', 'Sơn tính năng', 'Sơn sàn', 0, 'Thùng 18L', 'CÓ ĐỘ BÓNG CAO, CỨNG, CHẮC VÀ KHẢ NĂNG CHỊU TẢI TRỌNG', 'images/products/59e5d4fb6d87d.png'),
('LOT+ CHỐNG KIỀM VƯỢT TRỘI', 'Sơn ngoại thất', 'Sơn lót ngoại thất cao cấp', 1272000, '5 lít', 'SIÊU CHỐNG KIỀM CAO CẤP', 'images/products/619205724cb30.png'),
('PRIMER', 'Sơn ngoại thất', 'Sơn lót ngoại thất', 1061000, '5 lít', 'CHỐNG KIỀM, CHỐNG RÊU MỐC', 'images/products/619205a78e453.png'),
('LOT 3 IN 1 CHỐNG KIỀM VƯỢT TRỘI', 'Sơn lót', 'Sơn lót nội thất cao cấp', 886000, '5 lít', 'SIÊU CHỐNG KIỀM CAO CẤP', 'images/products/619205d6892a5.png'),
('SEALER', 'Sơn lót', 'Sơn lót nội thất', 725000, '5 lít', 'CHỐNG KIỀM, CHỊU PH CAO', 'images/products/6192061b83329.png'),
('PROTECTOR', 'Sơn ngoại thất', 'Bột trét tường nội & ngoại thất', 581000, '40 kg', 'CHỐNG KIỀM ĐẶC BIỆT', 'images/products/627087b59eb79.png'),
('SILK PLASTER', 'Sơn ngoại thất', 'Bột trét tường nội & ngoại thất', 555000, '40 kg', 'CHỐNG KIỀM VÀ TẠO MÀNG VƯỢT TRỘI', 'images/products/627087e33b0c3.png'),
('GJC TOUGH', 'Sơn ngoại thất', 'Sơn ngoại thất', 793000, '4.5 lít', 'ÍT TIÊU HAO, CHỐNG NẤM MỐC', 'images/products/6270883f00412.png'),
('ECO-SMOOTH', 'Sơn nội thất', 'Sơn nội thất', 0, 'Thùng 18L', 'DỄ SỬ DỤNG, ĐỘ CHE PHỦ CAO', 'images/products/629b2b707c5df.png'),
('ECO-PROTECT', 'Sơn ngoại thất', 'Sơn ngoại thất', 0, 'Thùng 18L', 'ĐỘ BÁM DÍNH CAO, CHỐNG NẤM MỐC', 'images/products/629b2ce392352.png'),
('AVATAR', 'Sơn nội thất', 'Sơn dầu', 350000, '3 lít', 'MÀNG SƠN BÓNG ĐẸP, BỀ MẶT MAU KHÔ', 'images/products/6192084e7625c.png');


-- NẠP TOÀN BỘ ĐẠI LÝ THỰC TẾ (126 ĐẠI LÝ)
truncate table public.dai_ly;
insert into public.dai_ly (ten_dai_ly, tinh_thanh, dia_chi, so_dien_thoai) values
('Cửa Hàng Trung Thông', 'TỈNH ĐẮK LẮK', 'Thôn 1, Xã Krong Jing, Huyện Madrac, Tỉnh Đắk Lắk', '0944246660'),
('NPP Nhung Đoàn', 'TỈNH PHÚ THỌ', 'Từ Du, Lập Thạch, Vĩnh Phúc', '0964306362'),
('Công ty TNHH Triều Hường', 'TỈNH NGHỆ AN', 'Xóm 6, Xã Diễn Mỹ, Huyện Diễn Châu, Tỉnh Nghệ An', '0945 582 109'),
('Đại Lý Lương Luận', 'TỈNH QUẢNG TRỊ', 'Thôn 1 Tú Loan, Quảng Hưng, Quảng Trạch, Quảng Bình', '0945 109 376'),
('DNTN Nhật Nhân', 'TỈNH VĨNH LONG', 'Ấp Chợ, Xã Tân Sơn, Huyện Trà Cú, Tỉnh Trà Vinh', ''),
('Đại lý Hoàng Giang', 'TỈNH HƯNG YÊN', '67 Trần Thái Tông, Phường Bồ Xuyên, Tp. Thái Bình, Tỉnh Thái Bình', '0912 641 283'),
('NPP sơn Galaxy Trịnh Uy', 'TP. HẢI PHÒNG', 'Ngã ba Thôn Cẩm La, Xã Thanh Sơn, Huyện Kiến Thuỵ, Tp. Hải Phòng', '0393099273'),
('NPP Cường Dung', 'TỈNH PHÚ THỌ', 'Tân Tiến, Vĩnh Tường, Vĩnh Phúc', '0857775889 - 0397879005'),
('Cửa Hàng Đình Phát', 'TỈNH ĐẮK LẮK', 'Số nhà 62, Đường Lý Thường Kiệt, Tổ dân phố 3, thị trấn Phước An, Huyện Krông Pắk, Daklak', '0941 077 575'),
('NPP Thanh Cường', 'TỈNH PHÚ THỌ', 'Khu 11, Kim Đức, TP. Việt Trì, Phú Thọ', '0378 502 000'),
('NPP Hòa Mỹ', 'TỈNH NINH BÌNH', 'Phố Tân Mỹ, Xã Ninh Mỹ, Huyện Hoa Lư, Tỉnh Ninh Bình', '0912932089'),
('Cửa Hàng Galaxy Long An', 'TỈNH TÂY NINH', 'Số 544, Ấp 5, Xã Phước Đông, Huyện Cần Đước, Tỉnh Long An', '0868 356 777 - 0368 449 449'),
('NPP Nam Sơn', 'TỈNH PHÚ THỌ', 'Thị Trấn Tam Sơn, Sông Lô, Vĩnh Phúc', '0989 091 156'),
('Cửa hàng Sơn Điều', 'TP. HÀ NỘI', 'Thôn Yên Thị, huyện Mê Linh, Tp. Hà Nội', '0987 617 628'),
('Cửa Hàng SÁU HIỆP', 'TỈNH CÀ MAU', 'Ấp Long Thành, Thị trấn Phước Long, Huyện Phước Long, Bạc Liêu', '0946.650.656'),
('Công ty TNHH TM Hòa Bình', 'TP. HÀ NỘI', 'Thôn Văn Giáp, Xã Văn Bình, Huyện Thường Tín, Tp. Hà Nội', '0913 510 636'),
('PHƯƠNG THẢO', 'TỈNH TÂY NINH', '504 Nguyễn Chí Thanh, Thị Trấn Dương Minh Châu, Tp. Tây Ninh, Tỉnh Tây Ninh', '0979.379.454'),
('Đại lý Bảo Phúc', 'TỈNH QUẢNG TRỊ', 'Số 200, Đường Lý Thái Tổ, Phường Bắc Nghĩa, Tp. Đồng Hới, Tỉnh Quảng Bình', '0974.059.111'),
('NPP Trường Mai', 'TỈNH HƯNG YÊN', 'Thị Trấn Ân Thi, Huyện Ân Thi, Hưng Yên', '0982 810 198'),
('NPP Năm Ninh', 'TỈNH GIA LAI', 'Thôn Lâm Trúc, Xã Hoài Thanh, Huyện Hoài Nhơn, Tỉnh Bình Định', '0977.949.695'),
('HKD Tiến Đạt', 'TỈNH ĐẮK LẮK', '163 Trần Hưng Đạo, P. An Lạc, Buôn Hồ, Đak Lak', '0932 437 438'),
('NPP Xuân Đỉnh', 'TỈNH NINH BÌNH', 'Xóm 11 B,  Xã Xuân Vinh, Huyện Xuân Trường, Nam Định', '0912 598 202'),
('NPP Mạnh Hiền', 'TP. HẢI PHÒNG', 'Thôn Thái Mông, Xã Phúc Thành, Huyệnh Kinh Môn, Tỉnh Hải Dương', '0973505076'),
('Hà Mùi', 'TỈNH THÁI NGUYÊN', 'Ký Phú,  H. Đại Từ, Thái Nguyên', '0982 961 236'),
('NPP Kiên Hường', 'TỈNH PHÚ THỌ', 'Xuân hòa, Lập thạch, Vĩnh Phúc', '0912 518 320'),
('NPP Trang Thọ', 'TỈNH BẮC NINH', 'Khu 4, P.Đại Phúc, TP Bắc Ninh, T Bắc Ninh', '0943907728'),
('CH Sơn và BBT Thành Nam', 'TP. HÀ NỘI', 'Số 22 - P16,  Ngõ 293 Tân Mai, Quận Hoàng Mai, Tp. Hà Nội', '0915 341 881'),
('Công ty TNHH XD TM Đại Nam T.H', 'TỈNH ĐỒNG NAI', '56 Đường Trần Hưng Đạo, Khu phố Phú Cường, Phường Tân Phú, TX. Đồng Xoài, Tỉnh Bình Phước', '0909823868'),
('NPP Tuyết Anh', 'TỈNH BẮC NINH', '287 Nguyễn Công Hãn, Phường Trần Nguyên Hãn, Tp. Bắc Giang, Tỉnh Bắc Giang', '0967 233 467'),
('NPP Diệu Linh', 'TỈNH QUẢNG NINH', '148 Hoàng Hoa Thám, Mạo Khê, Đông Triều, Quảng Ninh', '0969528058'),
('Cửa hàng Hoàng Quyên', 'TỈNH AN GIANG', '401, Trần Thị Hoa, Tổ 12, Ấp Bình Minh, Xã Bình Mỹ, H. Châu Phú, An Giang', '0916 333 031'),
('NPP Việt Châu', 'TỈNH PHÚ THỌ', 'Cầu Cát, Quất Lưu, Bình Xuyên, Vĩnh Phúc', '0962 921 366'),
('NPP Lâm Thao', 'TỈNH BẮC NINH', 'Xã Bồng Lai, Huyện Quế Võ, Bắc Ninh', '0941 748 989'),
('Đại Lý Phúc Dương Hòa', 'TỈNH ĐẮK LẮK', 'Thôn Ngọc Phước 1, Xã Bình Ngọc, Tp. Tuy Hòa, Tỉnh Phú Yên', ''),
('Cửa hàng VLXD Oanh', 'TỈNH LÂM ĐỒNG', 'Khu phố 1, Thị Trấn Tân Minh, Huyện Hàm Tân, Tỉnh Bình Thuận', '036 4122 022'),
('NPP Trung Thành', 'TỈNH HƯNG YÊN', 'Đình Cao, Phù Cừ, Hưng Yên', '0946886898'),
('HKD Khánh Linh', 'TỈNH LÂM ĐỒNG', 'Số 182, Nguyễn Trường Tộ, Khu Phố 3, P. Tân Thiện,  Thị xã Lagi, Tỉnh Bình Thuận', '0942694347'),
('NPP Anh Việt', 'TỈNH PHÚ THỌ', 'Thôn Dầu, Tử Du, Lập Thạch, Vĩnh Phúc', '0387833857'),
('Đại Lý Hưng Hường', 'TỈNH PHÚ THỌ', 'Đồng Ích, Lập Thạch, Vĩnh Phúc', '0912 742 771'),
('NPP Ngọc Giang', 'TỈNH BẮC NINH', 'Kinh Bắc, TP. Bắc Ninh, Bắc Ninh', '0989 760 283'),
('TẤN PHÁT KIẾN THÀNH', 'TỈNH CÀ MAU', 'Ấp 4, Xã Thới Bình, Huyện Thới Bình, Tỉnh Cà Mau', '0780.3860.229 - 0916.860.229 - 0908.228.209'),
('NPP Sơn Galaxy Lộc Điệp', 'TỈNH LẠNG SƠN', 'Xã Khuất Xá, Huyện Lộc Bình, Tỉnh Lạng Sơn', '0988222597'),
('NPP MINH TRÀ', 'TP. HÀ NỘI', '195 Đường Cầu Diễn, Từ Liêm, Hà Nội', '0962467868'),
('Công ty TNHH MTV Thịnh Thành Tiến', 'TỈNH AN GIANG', 'Số 19, Đường Dương Đông Cửa Cạn, Tổ 8, Khu phố 10, Xã Cửa Dương, Huyện Phú Quốc, Tỉnh Kiên Giang', '0974283336'),
('ĐẠI LÝ ĐĂNG NGUYÊN', 'TỈNH KHÁNH HÒA', '69 Lê Đại Hành, Tổ 10, TT Vạn Dã, Vạn Ninh, Khánh Hoà', '0987262050 - 0975379260'),
('NPP Tấn Nhung', 'TỈNH PHÚ THỌ', 'Khu độ thị Đầm Vạc, TP. Vĩnh Yên, Vĩnh Phúc', '0985 934 309'),
('Công Ty Cổ phần KT - XD Tâm Tài Tín', 'TP. HỒ CHÍ MINH', 'Số 280, Khu Phố Chiêu Liêu, Phường Tân Đông Hiệp, Thị xã Dĩ An, Tỉnh Bình Dương', ''),
('Công ty TNHH Ninh Hoàng Gia', 'TP. HẢI PHÒNG', '83 Nguyễn Văn Linh, Tp. Hải Phòng', '0904 309 179'),
('Công ty CP TM & XD Phúc Lộc Sơn', 'TỈNH PHÚ THỌ', 'LK 10-03, khu D, KĐT Sinh Thái Sông Hồng, Nam Đầm Vạc, P.Khai Quang, Vĩnh Yên, Vĩnh Phúc', '0966555882'),
('CỬA HÀNG SƠN VÀ BỘT BẢ HỒNG TIẾN', 'TP. HÀ NỘI', '262 Nguyễn Xiển, Hạ Đình, Quận Thanh Xuân, Tp. Hà Nội', '0987 525 879'),
('Cty TNHH TMXD Phi Hùng', 'TỈNH LÂM ĐỒNG', 'Tổ 2, Phường Nghĩa Tân, Thị xã Gia Nghĩa, Tỉnh Đắk Nông', '0977 635 678'),
('NPP Cty Sơn Minh Hùng', 'TỈNH NINH BÌNH', 'Số 38 Trường Chinh, Tp. Nam Định, Tỉnh Nam Định', '03503846723 - 0913299158'),
('Đại lý Vân Hiếu', 'TỈNH QUẢNG NGÃI', 'Xã Nghĩa Hiệp, Huyện Tư Nghĩa, tỉnh Quảng Ngãi', '0397 538 987'),
('NPP Sơn Galaxy Huy Phát', 'TỈNH ĐỒNG NAI', 'Tổ 15, Ấp 6, Vĩnh tân, Vĩnh Cửu, Đồng Nai', '0978 122 574'),
('Đại Lý Tiến Phát', 'TỈNH GIA LAI', '235B Cách Mạng Tháng 8, Phường Hoa Lư, Tp. Pleiku, Tỉnh Gia Lai', ''),
('Đại Lý Vượng Hồng', 'TỈNH PHÚ THỌ', 'Vinh Phú, TT Hợp Hòa, Tam Dương, Vĩnh Phúc', '0985 934 309'),
('NPP Sơn Hiền', 'TỈNH THÁI NGUYÊN', '207 Hoàng Văn Thụ , Tp. Thái Nguyên, Tỉnh Thái Nguyên', '0983 149 777'),
('Cửa Hàng Vật  Liệu Xây Dựng GIA HÂN', 'TỈNH AN GIANG', 'Ấp An Thuận –  xã Hoà Bình –  huyện Chợ Mới –  tỉnh An Giang', '0939 619 131'),
('Công ty TNHH MTV Phương Tiến Lộc', 'TP. ĐÀ NẴNG', 'H74/4/58 Hoàng Văn Thái, P. Hòa Khánh Nam, Q. Liên Chiểu, TP. Đà Nẵng', '0935 012 367'),
('ĐẠI LÝ SAO VIỆT SVC', 'TP. HỒ CHÍ MINH', '50/1D Đường 26, Khu Phố 5, P. Hiệp Bình Chánh, Thủ Đức, Tp.HCM', '0908.883.461'),
('NPP Thanh Chính', 'TỈNH BẮC NINH', 'Xã Quang Thịnh, Huyện Lạng Giang, Tỉnh Bắc Giang', '0979550668'),
('Công Ty TNHH XD & TM Huy Hoàn', 'TỈNH NINH BÌNH', 'Số 120 Đường Quy Lưu, Phường Minh Khai, Tp. Phủ Lý, Tỉnh Hà Nam', '0351 385 3488'),
('Lan Hưng', 'TỈNH THÁI NGUYÊN', 'Xóm Trung Tâm, Xã Phúc Xuân, TP Thái Nguyên', '0973269778'),
('SAO VIỆT (KHÁNH LINH)', 'TP. HỒ CHÍ MINH', '14 Đội Cấn, Phường 8, Tp. Vũng Tàu, Tỉnh Bà Rịa Vũng Tàu', '0907.892.462'),
('HKD Cơ Sở Văn Vũ', 'TỈNH LÂM ĐỒNG', 'Khu phố 5, TT Tân Nghĩa, Hàm tân, Bình Thuận', '0972 845 294'),
('NPP Cần Thanh', 'TỈNH PHÚ THỌ', 'TT Thanh Lãng, Bình Xuyên, Vĩnh Phúc', '0915205643'),
('NPP Vinh Quang', 'TP. HẢI PHÒNG', 'Xã Vinh Quang, Huyện Tiên Lãng, Thành phố Hải Phòng', ''),
('NPP Tiệp Oanh', 'TỈNH NGHỆ AN', 'Xóm Quyết Thắng , Xã Diễn Bích , Huyện Diễn Châu, Tỉnh Nghệ An', '0963953347'),
('Đại lý Sơn Galaxy Lâm An', 'TỈNH QUẢNG TRỊ', 'Thôn Tân Tiến, Xã Tân Liên, Huyện Hướng Hóa, Tỉnh Quảng Trị', ''),
('NPP Minh Khương', 'TỈNH PHÚ THỌ', 'Lãng Công, Sông Lô, Vĩnh Phúc', '0967502383'),
('Công ty CP Tuấn Đức Lạng Sơn', 'TỈNH LẠNG SƠN', 'Số 22/2, khu Tái định cư Mỹ Sơn, Phường Vĩnh Trại, Tp. Lạng Sơn, Tỉnh Lạng Sơn.', '0912909294'),
('CÔNG TY TNHH KINH DOANH VÀ PHÁT TRIỂN TRƯỜNG PHONG', 'TP. HÀ NỘI', 'Thôn Liên Minh, Xã Thụy An, Huyện Ba Vì, Thành Phố Hà Nội', '0988 97 88 82'),
('NPP Tiến Đạt', 'TỈNH NINH BÌNH', 'Chợ Bến, Xã Khánh Thượng, Huyện Yên Mô, Tỉnh Ninh Bình', ''),
('Đại lý Hải Loan', 'TP. HÀ NỘI', 'Xã Thượng Mỗ, Huyện Đan Phượng, Tp. Hà Nội', '01683 522 144'),
('NPP Thắng Hoài', 'TỈNH BẮC NINH', 'Đường 279, Phố Chì, Bồng Lai, Quế Võ, Bắc Ninh', '036 404 2282'),
('Cty TNHH MTV TM Toàn Lộc Sơn', 'TỈNH PHÚ THỌ', 'Số 40 Phố Nhuế Khúc, Phường Hùng Vương, Tp. Phúc Yên, Tỉnh Vĩnh Phúc', '0967 277 281'),
('NPP Mai Dân', 'TP. HẢI PHÒNG', 'KDT Thanh Quang, Quốc Tuấn, Nam Sách, Hải Dương', '0966240496'),
('NPP Anh Ngọc', 'TỈNH PHÚ THỌ', 'Thôn Trung Nguyên, xã Trung Nguyên, Yên lạc, Vĩnh Phúc', '0983 615 676'),
('Đại lý Thành Đại', 'TP. HẢI PHÒNG', '219 Đường Trần Hưng Đạo, Tp. Hải Dương, Tỉnh Hải Dương', '0912 428 784'),
('Cửa Hàng VLXD MAI NAM', 'TỈNH AN GIANG', 'Ấp Long Hoà 2, Xã Long Điền A,  Huyện Chợ Mới,  Tỉnh An Giang, Việt Nam', '0977 727 927'),
('Đại Lý Hiền Hiệp', 'TỈNH BẮC NINH', 'Khu Đường Xá 3, Vạn Anm Tp. Bắc Ninh', '0944 731 979'),
('Đại Lý Thuy Yến', 'TỈNH THÁI NGUYÊN', 'Tiền Phong, Phổ Yên, Thái Nguyên', '0344 449 998'),
('Đại lý sơn Galaxy Hoàng Thương', 'TP. HUẾ', 'Số 93, Đường Huỳnh Thúc Kháng, Tp. Huế', ''),
('Cửa hàng Thái Bảo', 'TP. HỒ CHÍ MINH', '63A Đống Đa, P. Thắng Nhất, Tp. Vũng Tàu', '0977 971 944'),
('NPP SƠN GALAXY HOÀNG TẤN', 'TP. HỒ CHÍ MINH', '341 Đường Giồng Anm Ấp Giồng An, Cần Thạnh, Cần Giờ', '0937 878 449 - 0937 515 449'),
('CỬA HÀNG HOÀNG KHANH', 'TỈNH TÂY NINH', 'Số 220 - đường Điện Biên Phủ - Khu phố Ninh Tân -  Phuòng Ninh Sơn -  Thành Phố Tây Ninh -  Tỉnh Tây Ninh', '0915 373 803'),
('NPP Cty TNHH Thái Sơn', 'TỈNH LẠNG SƠN', 'Khối 5, Quốc lộ 1A, Thị trấn Cao Lộc, Huyện Cao Lộc, Tỉnh Lạng Sơn', '0913555905'),
('Cửa hàng Dũng Phương', 'TỈNH QUẢNG TRỊ', 'Quốc lộ 1A, Thôn Xuân Kiều, Xã Quảng Xuân, Huyện Quảng Trạch, Tỉnh Quảng Bình', '01663381858'),
('NPP Mạnh Dũng', 'TỈNH NINH BÌNH', 'Tổ 18, Thị trấn Xuân Trường, Huyện Xuân Trường, Tỉnh Nam Định', '0976 536 068'),
('HKD THANH LÂM', 'TP. HỒ CHÍ MINH', 'Số 210/5 Thạnh Sơn A,  Xã Phước Tân,  Huyện Xuyên Mộc,  TP. Vũng Tàu', ''),
('Đại Lý Tín Linh', 'TP. HẢI PHÒNG', 'Thôn Vĩnh Khê, Xã An Đồng, Huyện An Dương, TP Hải Phòng', '0936597468'),
('Đại Lý  Sơn Trang (HKD Nguyễn Văn Thiều)', 'TỈNH NINH BÌNH', 'Xã Gia Hòa, Huyện Gia Viễn, Ninh Bình', '0969695735'),
('HKD TRƯỜNG HƯNG', 'TP. CẦN THƠ', '135A, Ấp Hòa Mỹ, Thị trấn Mỹ Xuyên, Sóc Trăng', '0939 360 061'),
('NPP Hữu Phong', 'TỈNH BẮC NINH', 'Xóm 2, Thôn Đông Sơn, Xã Việt Đoàn, Huyện Tiên Du, Tỉnh Bắc Ninh', ''),
('Cửa Hàng Hoàng Yến', 'TỈNH ĐỒNG NAI', 'Tổ 5, KP3, phường Tân Đồng, Tp. Đồng Xoài, Tỉnh Bình Phước', '0913.244.379'),
('Đại Lý Văn Khánh', 'TỈNH PHÚ THỌ', 'Tử Du, Lập Thạch, Vĩnh Phúc', '0976 224 878 - 0989 156 531'),
('NPP Sơn Galaxy Thuận Phát', 'TỈNH ĐỒNG THÁP', '563 Quốc lộ 50, Ấp Mỹ Hưng, Xã Mỹ Phong, TP. Mỹ Tho, Tiền Giang', '0903 660 576 - 02733 970 833'),
('Cửa hàng Anh Thư Galaxy', 'TỈNH ĐẮK LẮK', 'Số 356, Giải Phóng, TT. Phướx An, Huyện Krông Pắk, Đaklak', '0917.664.558'),
('NPP Âu Kiên', 'TỈNH HƯNG YÊN', 'Xã Xuân Quan, Huyện Văn Giang, Tỉnh Hưng Yên', '0982 723 063'),
('NPP Sơn Galaxy Minh Châu', 'TỈNH NINH BÌNH', 'Số 408 phố Thống Nhất, Thị trấn Me, Huyện Gia Viễn, Tỉnh Ninh Bình', '0943671386'),
('Đại lý Hùng Uyên', 'TỈNH LÀO CAI', 'Tổ 10, Phường Trung Tâm, Thị xã Nghĩa Lộ, Tỉnh Yên Bái', '0293 870 617'),
('Cửa Hàng Năm Chiêu', 'TỈNH LÂM ĐỒNG', '104 Lê Thánh Tôn, Thôn Hiệp Hòa, Xã Tân Hải, TX. Lagi, Bình Thuận', '0338 748 562 - 0937 936 306'),
('Đại lý Thủy Tá', 'TỈNH THANH HÓA', 'Thị xã Bỉm Sơn, Tỉnh Thanh Hóa', '0914 886 319'),
('CH Gạch men & TTNT Phát Lộc Phát', 'TỈNH ĐỒNG NAI', '27 Hương Lộ 19, Ấp Quới Thạnh, Xã Phước An, H. Nhơn Trạch, Đồng Nai', '0988581818 - 0967113939'),
('Đại lý Lan Anh', 'TP. HUẾ', 'Chợ Điền Lộc, Phong Điền, Thừa Thiên Huế', '0852 769 239 - 0777 061 935'),
('Công ty TNHH Đầu Tư Tú Long', 'TỈNH BẮC NINH', 'Thôn Đại Vi, Xã Đại Đồng, Huyện Tiên Du, Tỉnh Bắc Ninh', '0912 639 336'),
('NPP Ngọc Thái', 'TỈNH HƯNG YÊN', 'Đinh Dù, Văn Lâm, Hưng Yên', '0912 558 011'),
('Đại lý Sơn Galaxy Sơn Thủy', 'TP. ĐÀ NẴNG', 'Thôn Lang Châu Nam, Xã Duy Phước, Huyện Duy Xuyên, Tỉnh Quảng Nam', ''),
('HỮU TRÂN', 'TỈNH AN GIANG', '460 Ngô Quyền, Phường Vĩnh Lạc, Tp. Rạch Giá, Tỉnh Kiên Giang', '0907.528.598'),
('Đại Lý Hải Yến', 'TỈNH QUẢNG TRỊ', 'QL1A, Thôn Minh Sơn, Xã Quảng Đông, H. Quảng Trạch, Quảng Bình', '097 906 989'),
('TÂN LỘC PHÁT', 'TỈNH TÂY NINH', '21 Đường số 26, QL22B, Ấp Bình Trung, TP.Tây Ninh, Tây Ninh', '0987.175.152 - 0948.240.978'),
('Cửa Hàng Huy Phúc Thịnh', 'TỈNH QUẢNG TRỊ', '25 Lãn Ông , TP.Đông Hà, tỉnh Quảng Trị', '0934 984 080'),
('NPP Hải Thu', 'TỈNH PHÚ THỌ', 'Thôn Phú Đa, Vĩnh Tường, Vĩnh Phúc', '0971576333'),
('Đại Lý Bảo An', 'TỈNH QUẢNG TRỊ', 'Thôn Phan Xá, xã Xuân Thủy, huyện Lệ Thủy, Quảng Bình', '0902317586'),
('NPP TRƯỜNG XUÂN', 'TP. HÀ NỘI', 'Kỳ Đồng, Tiến Thịnh, Mê Linh, Hà Nội', '08 6666 7997'),
('Công ty TNHH Thái Trường Yên', 'TỈNH GIA LAI', 'Số nhà 54, Đường Nguyễn Thị Định, Phường Nguyễn Văn Cừ, Tp. Quy Nhơn', '0912 604 038'),
('Đại lý Trường Xuân', 'TỈNH QUẢNG TRỊ', '52 Lê Duẩn, Hướng Hóa, Quảng Trị', '0813686456'),
('Cửa Hàng TÚ QUYÊN', 'TỈNH CÀ MAU', 'ấp Tam Hưng, xã Vĩnh Hưng huyện Vĩnh Lợi, tỉnh Bạc Liêu', '0945 490 581 - 0947 986 350'),
('NPP Sơn Galaxy Thường Liễu', 'TỈNH BẮC NINH', 'Thôn Công Cối, Xã Đại Xuân, Huyện Quế Võ, Tỉnh Bắc Ninh', '0988134688'),
('Đại lý Kiên Huế', 'TỈNH BẮC NINH', 'Xã Trường Sơn, Huyện Lục Nam, Tp. Bắc Giang, Tỉnh Bắc Giang', '082 884 9416'),
('NPP Hải Ngân', 'TỈNH PHÚ THỌ', 'Số 60, Nguyễn Thị Minh Khai, Hộp Hợp, Vĩnh Yên, Vĩnh Phúc', '0963 890 899'),
('NPP Định Huế', 'TỈNH HƯNG YÊN', 'Xã Tân Dân, Huyện Khoái Châu, Tỉnh Hưng Yên', '0986 070 838'),
('Đại Lý Linh Trang', 'TỈNH GIA LAI', 'Thôn Plei Mun Măk, Xã Ia Ke, Huyện Phú Thiện, Gia Lai', '0935 943 220 - 0905 507 304'),
('NPP NHẬT HẢO', 'TP. HÀ NỘI', 'Vạn Phúc, Vạn Yên, Mê Linh, Hà Nội', '0983314570'),
('Đại lý Hà Văn Học', 'TP. HÀ NỘI', 'Thôn Thạch Lỗi, Xã Thanh Xuân, Huyện Sóc Sơn, Tp. Hà Nội', '0985 416 955'),
('Đại lý Sơn Thanh Tiến Phát', 'TỈNH ĐỒNG NAI', 'Tổ 13B, đường Hàm Nghi, Ấp Ruộng Hời,  Xã.Bảo Vinh, TX. Long Khánh,  Tỉnh. Đồng Nai', '0948 778 291');

-- NẠP ĐỘI THỢ SƠN TIÊU BIỂU
truncate table public.tho_son;
insert into public.tho_son (ten_tho, tinh_thanh, so_dien_thoai) values
('Đội thợ sơn Nguyễn Văn Hùng', 'TP. HÀ NỘI', '0982 345 678'),
('Đội thi công Trần Đình Quý', 'TP. HỒ CHÍ MINH', '0912 888 999'),
('Đội thợ sơn Lê Văn Thắng', 'TP. ĐÀ NẴNG', '0977 456 123'),
('Đội thợ thi công Hải Phòng Pro', 'TP. HẢI PHÒNG', '0905 111 222'),
('Đội thợ sơn Hoàng Minh Cần Thơ', 'TP. CẦN THƠ', '0939 678 899'),
('Đội thợ Cố đô Huế', 'TP. HUẾ', '0914 222 333');
