/**
 * Supabase Client & Helper Functions for Galaxy Paint
 * Tự động đồng bộ và lưu trữ dữ liệu Khách 4 bước, Phối màu & Liên hệ
 */
(function () {
    const SUPABASE_URL = 'https://dwmpbrfjlufjkknknfsp.supabase.co';
    const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3bXBicmZqbHVmamtrbmtuZnNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgwNzM3NzcsImV4cCI6MjEwMzY0OTc3N30.SWuEGWPRBLiC4J6txNha0AAP-IO_wzSfoIQ6sFpm5Kg';
    const SUPABASE_REST = `${SUPABASE_URL}/rest/v1`;

    const apiHeaders = {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': 'Bearer ' + SUPABASE_ANON_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    };

    let supabaseClient = null;

    function getSupabase() {
        if (supabaseClient) return supabaseClient;
        if (window.supabase && typeof window.supabase.createClient === 'function') {
            supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
            return supabaseClient;
        }
        return null;
    }

    window.GalaxyDB = {
        url: SUPABASE_URL,
        anonKey: SUPABASE_ANON_KEY,
        getClient: getSupabase,

        // 1. Lưu thông tin 4 bước sơn nhà
        async saveLead4Step(leadData) {
            const payload = {
                ho_ten: leadData.ho_ten || leadData.name || 'Khách hàng',
                so_dien_thoai: leadData.so_dien_thoai || leadData.phone || '',
                email: leadData.email || '',
                tinh_thanh: leadData.tinh_thanh || '',
                mau_son: leadData.mau_son || '',
                dien_tich: Number(leadData.dien_tich) || 0,
                du_toan_chi_phi: Number(leadData.du_toan_chi_phi) || 0,
                dai_ly: leadData.dai_ly || '',
                tho_son: leadData.tho_son || '',
                ma_giam_gia: leadData.ma_giam_gia || '',
                trang_thai: 'Chưa liên hệ'
            };

            try {
                // Ưu tiên gửi trực tiếp qua Supabase REST API (độc lập, không phụ thuộc CDN)
                const res = await fetch(`${SUPABASE_REST}/leads_4step`, {
                    method: 'POST',
                    headers: apiHeaders,
                    body: JSON.stringify(payload)
                });

                if (res.ok) {
                    const data = await res.json();
                    console.log('✓ GalaxyDB: Đã lưu thông tin 4 bước sơn vào Supabase thành công:', data);
                    return { success: true, data };
                } else {
                    const errText = await res.text();
                    console.warn('GalaxyDB Warning: Không thể lưu lead (RLS hoặc lỗi bảng):', errText);
                    if (errText.includes('row-level security')) {
                        console.info('💡 Gợi ý: Hãy chạy script database/mo_quyen_supabase_va_chuong_trinh.sql trên Supabase SQL Editor.');
                    }
                    return { success: false, error: errText };
                }
            } catch (err) {
                console.error('Lỗi kết nối Supabase leads_4step:', err);
                return { success: false, error: err };
            }
        },

        // 2. Lưu yêu cầu phối màu miễn phí
        async savePhoiMau(phoiMauData, fileUpload) {
            let imageUrl = '';
            const client = getSupabase();

            // Nếu có tệp ảnh công trình tải lên, đưa lên Supabase Storage
            if (fileUpload && fileUpload instanceof File && client) {
                try {
                    const fileExt = fileUpload.name.split('.').pop();
                    const fileName = `${Date.now()}_${Math.random().toString(36).substring(2, 8)}.${fileExt}`;
                    const { data: uploadData, error: uploadErr } = await client.storage
                        .from('anh-cong-trinh')
                        .upload(fileName, fileUpload);

                    if (!uploadErr && uploadData) {
                        const { data: publicUrlData } = client.storage
                            .from('anh-cong-trinh')
                            .getPublicUrl(fileName);
                        imageUrl = publicUrlData ? publicUrlData.publicUrl : '';
                    }
                } catch (e) {
                    console.warn('Lỗi tải ảnh công trình lên storage:', e);
                }
            }

            const payload = {
                ho_ten: phoiMauData.ho_ten || 'Khách phối màu',
                so_dien_thoai: phoiMauData.so_dien_thoai || '',
                dia_chi: phoiMauData.dia_chi || '',
                loai_cong_trinh: phoiMauData.loai_cong_trinh || '',
                anh_cong_trinh_url: imageUrl || phoiMauData.anh_cong_trinh_url || '',
                tong_mau_yeu_thich: phoiMauData.tong_mau_yeu_thich || '',
                trang_thai: 'Chưa liên hệ'
            };

            try {
                const res = await fetch(`${SUPABASE_REST}/yeu_cau_phoi_mau`, {
                    method: 'POST',
                    headers: apiHeaders,
                    body: JSON.stringify(payload)
                });

                if (res.ok) {
                    const data = await res.json();
                    console.log('✓ GalaxyDB: Đã lưu yêu cầu phối màu thành công:', data);
                    return { success: true, data };
                } else {
                    const errText = await res.text();
                    console.warn('GalaxyDB: Lỗi lưu phối màu:', errText);
                    return { success: false, error: errText };
                }
            } catch (err) {
                console.error('Lỗi kết nối Supabase yeu_cau_phoi_mau:', err);
                return { success: false, error: err };
            }
        },

        // 3. Lưu thông tin tin nhắn liên hệ
        async saveLienHe(lienHeData) {
            const payload = {
                ho_ten: lienHeData.ho_ten || 'Khách liên hệ',
                so_dien_thoai: lienHeData.so_dien_thoai || '',
                email: lienHeData.email || '',
                noi_dung: lienHeData.noi_dung || ''
            };

            try {
                const res = await fetch(`${SUPABASE_REST}/lien_he`, {
                    method: 'POST',
                    headers: apiHeaders,
                    body: JSON.stringify(payload)
                });

                if (res.ok) {
                    const data = await res.json();
                    console.log('✓ GalaxyDB: Đã lưu tin nhắn liên hệ thành công:', data);
                    return { success: true, data };
                } else {
                    const errText = await res.text();
                    console.warn('GalaxyDB: Lỗi lưu liên hệ:', errText);
                    return { success: false, error: errText };
                }
            } catch (err) {
                console.error('Lỗi kết nối Supabase lien_he:', err);
                return { success: false, error: err };
            }
        }
    };
})();
