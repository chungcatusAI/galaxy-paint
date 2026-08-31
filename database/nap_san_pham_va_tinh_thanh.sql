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

-- 4. NẠP 34 TỈNH THÀNH CHUẨN MỚI TỪ 1/7/2025
truncate table public.tinh_thanh;
insert into public.tinh_thanh (ten_tinh, mien, ghi_chu_sap_nhap, thu_tu) values
('TP. HÀ NỘI', 'Bắc', 'Giữ nguyên', 1),
('TP. HỒ CHÍ MINH', 'Nam', 'Sáp nhập TP.HCM + Bình Dương + Bà Rịa Vũng Tàu', 2),
('TP. HẢI PHÒNG', 'Bắc', 'Sáp nhập Hải Phòng + Hải Dương', 3),
('TP. ĐÀ NẴNG', 'Trung', 'Sáp nhập Đà Nẵng + Quảng Nam', 4),
('TP. CẦN THƠ', 'Nam', 'Sáp nhập Cần Thơ + Sóc Trăng + Hậu Giang', 5),
('TP. HUẾ', 'Trung', 'Thành lập TP trực thuộc TW từ Thừa Thiên Huế', 6),
('TỈNH BẮC NINH', 'Bắc', 'Sáp nhập Bắc Ninh + Bắc Giang', 7),
('TỈNH CÀ MAU', 'Nam', 'Sáp nhập Cà Mau + Bạc Liêu', 8),
('TỈNH CAO BẰNG', 'Bắc', 'Giữ nguyên', 9),
('TỈNH ĐIỆN BIÊN', 'Bắc', 'Giữ nguyên', 10),
('TỈNH ĐẮK LẮK', 'Trung', 'Sáp nhập Đắk Lắk + Phú Yên', 11),
('TỈNH ĐỒNG NAI', 'Nam', 'Sáp nhập Đồng Nai + Bình Phước', 12),
('TỈNH ĐỒNG THÁP', 'Nam', 'Sáp nhập Đồng Tháp + Tiền Giang', 13),
('TỈNH GIA LAI', 'Trung', 'Sáp nhập Gia Lai + Bình Định', 14),
('TỈNH HÀ TĨNH', 'Trung', 'Giữ nguyên', 15),
('TỈNH HƯNG YÊN', 'Bắc', 'Sáp nhập Hưng Yên + Thái Bình', 16),
('TỈNH KHÁNH HÒA', 'Trung', 'Sáp nhập Khánh Hòa + Ninh Thuận', 17),
('TỈNH LAI CHÂU', 'Bắc', 'Giữ nguyên', 18),
('TỈNH LÂM ĐỒNG', 'Trung', 'Sáp nhập Lâm Đồng + Đắk Nông + Bình Thuận', 19),
('TỈNH LẠNG SƠN', 'Bắc', 'Giữ nguyên', 20),
('TỈNH LÀO CAI', 'Bắc', 'Sáp nhập Lào Cai + Yên Bái', 21),
('TỈNH NGHỆ AN', 'Trung', 'Giữ nguyên', 22),
('TỈNH NINH BÌNH', 'Bắc', 'Sáp nhập Ninh Bình + Hà Nam + Nam Định', 23),
('TỈNH PHÚ THỌ', 'Bắc', 'Sáp nhập Phú Thọ + Vĩnh Phúc + Hòa Bình', 24),
('TỈNH QUẢNG NGÃI', 'Trung', 'Sáp nhập Quảng Ngãi + Kon Tum', 25),
('TỈNH QUẢNG NINH', 'Bắc', 'Giữ nguyên', 26),
('TỈNH QUẢNG TRỊ', 'Trung', 'Sáp nhập Quảng Trị + Quảng Bình', 27),
('TỈNH SƠN LA', 'Bắc', 'Giữ nguyên', 28),
('TỈNH TÂY NINH', 'Nam', 'Sáp nhập Tây Ninh + Long An', 29),
('TỈNH THÁI NGUYÊN', 'Bắc', 'Sáp nhập Thái Nguyên + Bắc Kạn', 30),
('TỈNH THANH HÓA', 'Bắc', 'Giữ nguyên', 31),
('TỈNH TUYÊN QUANG', 'Bắc', 'Sáp nhập Tuyên Quang + Hà Giang', 32),
('TỈNH VĨNH LONG', 'Nam', 'Sáp nhập Vĩnh Long + Bến Tre + Trà Vinh', 33),
('TỈNH AN GIANG', 'Nam', 'Sáp nhập An Giang + Kiên Giang', 34);

-- 5. NẠP TOÀN BỘ 47 SẢN PHẨM & GIÁ BÁN THỰC TẾ
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
('LOT+ CHỐNG KIỀM VƯỢT TRỘI', 'Sơn lót', 'Sơn lót ngoại thất cao cấp', 1272000, '5 lít', 'SIÊU CHỐNG KIỀM CAO CẤP', 'images/products/619205724cb30.png'),
('PRIMER', 'Sơn lót', 'Sơn lót ngoại thất', 1061000, '5 lít', 'CHỐNG KIỀM, CHỐNG RÊU MỐC', 'images/products/619205a78e453.png'),
('LOT 3 IN 1 CHỐNG KIỀM VƯỢT TRỘI', 'Sơn lót', 'Sơn lót nội thất cao cấp', 886000, '5 lít', 'SIÊU CHỐNG KIỀM CAO CẤP', 'images/products/619205d6892a5.png'),
('SEALER', 'Sơn lót', 'Sơn lót nội thất', 725000, '5 lít', 'CHỐNG KIỀM, CHỊU PH CAO', 'images/products/6192061b83329.png'),
('PROTECTOR', 'Bột trét tường', 'Bột trét tường nội & ngoại thất', 581000, '40 kg', 'CHỐNG KIỀM ĐẶC BIỆT', 'images/products/627087b59eb79.png'),
('SILK PLASTER', 'Bột trét tường', 'Bột trét tường nội & ngoại thất', 555000, '40 kg', 'CHỐNG KIỀM VÀ TẠO MÀNG VƯỢT TRỘI', 'images/products/627087e33b0c3.png'),
('SILK PLASTER NỘI THẤT', 'Bột trét tường', 'Bột trét tường nội thất', 520000, '40 kg', 'CHỐNG KIỀM VÀ TẠO BỀ MẶT LÁNG MỊN', 'images/products/6270880c4961a.png'),
('GJC TOUGH', 'Sơn ngoại thất', 'Sơn ngoại thất', 793000, '4.5 lít', 'ÍT TIÊU HAO, CHỐNG NẤM MỐC', 'images/products/6270883f00412.png'),
('ECO-SMOOTH', 'Sơn nội thất', 'Sơn nội thất', 0, 'Thùng 18L', 'DỄ SỬ DỤNG, ĐỘ CHE PHỦ CAO', 'images/products/629b2b707c5df.png'),
('ECO-PROTECT', 'Sơn ngoại thất', 'Sơn ngoại thất', 0, 'Thùng 18L', 'ĐỘ BÁM DÍNH CAO, CHỐNG NẤM MỐC', 'images/products/629b2ce392352.png'),
('AVATAR', 'Sơn tính năng', 'Sơn dầu', 350000, '3 lít', 'MÀNG SƠN BÓNG ĐẸP, BỀ MẶT MAU KHÔ', 'images/products/6192084e7625c.png');

