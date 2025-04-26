/* 1. Tạo các Node thích hợp */

// HocVien
CREATE
  (:HocVien {maHV: 1, ho: 'Nguyen', ten: 'Chanh Dai', diaChi: 'TP. HCM', gioiTinh: 'Nam', namSinh: 2000}),
  (:HocVien {maHV: 2, ho: 'Ngo', ten: 'Thanh Tam', diaChi: 'TP. HCM', gioiTinh: 'Nữ', namSinh: 2000}),
  (:HocVien {maHV: 3, ho: 'Nguyen', ten: 'Thanh Ut', diaChi: 'TP. Can Tho', gioiTinh: 'Nam', namSinh: 1972}),
  (:HocVien {maHV: 4, ho: 'Nguyen', ten: 'Thi Thu', diaChi: 'TP. Can Tho', gioiTinh: 'Nữ', namSinh: 1976})

// KhoaHoc
CREATE
  (:KhoaHoc {maKH: 1, ten: 'Learn Python: Fundamentals', soBuoi: 30}),
  (:KhoaHoc {maKH: 2, ten: 'Learn TypeScript: Fundamentals', soBuoi: 28}),
  (:KhoaHoc {maKH: 3, ten: 'Generative AI: Prompt Engineering Basics', soBuoi: 36})

// PhongHoc
CREATE
  (:PhongHoc {maPH: 1, tenPhong: 'D100'}),
  (:PhongHoc {maPH: 2, tenPhong: 'D105'})

// DoAn
CREATE
  (:DoAn {maDA: 1, tenDA: 'Text to Video by AI'}),
  (:DoAn {maDA: 2, tenDA: 'Face Recognition Tool'}),
  (:DoAn {maDA: 12, tenDA: 'Quiz Web App'})

/* 2. Tạo mối quan hệ giữa các Node */

// HocVien tham gia KhoaHoc

MATCH (hv1:HocVien {maHV: 1}), (kh1:KhoaHoc {maKH: 1})
      CREATE (hv1)-[:THAM_GIA]->(kh1)

MATCH (hv2:HocVien {maHV: 2}), (kh2:KhoaHoc {maKH: 2})
      CREATE (hv2)-[:THAM_GIA]->(kh2)

MATCH (hv3:HocVien {maHV: 3}), (kh1:KhoaHoc {maKH: 1})
      CREATE (hv3)-[:THAM_GIA]->(kh1)

MATCH (hv4:HocVien {maHV: 4}), (kh3:KhoaHoc {maKH: 3})
      CREATE (hv4)-[:THAM_GIA]->(kh3)

// KhoaHoc diễn ra tại PhongHoc

MATCH (kh1:KhoaHoc {maKH: 1}), (ph1:PhongHoc {maPH: 1})
CREATE (kh1)-[:DIEN_RA_TAI]->(ph1)

MATCH (kh2:KhoaHoc {maKH: 2}), (ph2:PhongHoc {maPH: 2})
CREATE (kh2)-[:DIEN_RA_TAI]->(ph2)

MATCH (kh3:KhoaHoc {maKH: 3}), (ph2:PhongHoc {maPH: 2})
CREATE (kh3)-[:DIEN_RA_TAI]->(ph2)

// HocVien làm DoAn (có số giờ làm việc)

MATCH (hv1:HocVien {maHV: 1}), (da1:DoAn {maDA: 1})
CREATE (hv1)-[:LAM_DO_AN {soGio: 50}]->(da1)

MATCH (hv1:HocVien {maHV: 1}), (da2:DoAn {maDA: 2})
CREATE (hv1)-[:LAM_DO_AN {soGio: 30}]->(da2)

MATCH (hv2:HocVien {maHV: 2}), (da2:DoAn {maDA: 2})
CREATE (hv2)-[:LAM_DO_AN {soGio: 40}]->(da2)

MATCH (hv3:HocVien {maHV: 3}), (da3:DoAn {maDA: 12})
CREATE (hv3)-[:LAM_DO_AN {soGio: 30}]->(da3)

MATCH (hv4:HocVien {maHV: 4}), (da3:DoAn {maDA: 12})
CREATE (hv4)-[:LAM_DO_AN {soGio: 35}]->(da3)

/* 3. Kiểm tra thông tin bằng cách liệt kê tất cả các Node sau khi tạo */

MATCH (n)
RETURN n

/* 4. Dùng ngôn ngữ Cypher truy vấn các thông tin */

// Tìm tất cả thông tin học viên có địa chỉ "TP. HCM". Thông tin trả về bao gồm họ tên học viên, địa chỉ, giới tính, năm sinh, sắp xếp giảm dần theo họ học viên.

MATCH (hv:HocVien)
WHERE toLower(hv.diaChi) CONTAINS 'tp. hcm'
RETURN hv.ho AS ho, hv.ten AS ten, hv.diaChi AS diaChi, hv.gioiTinh AS gioiTinh, hv.namSinh AS namSinh
ORDER BY hv.ho DESC

// Tìm tất cả các khóa học có số buổi lớn hơn 32. Thông tin trả về bao gồm tên khóa học, số buổi, sắp xếp giảm dần theo số lượng buổi học.

MATCH (kh:KhoaHoc)
WHERE kh.soBuoi > 32
RETURN kh.ten AS tenKhoaHoc, kh.soBuoi AS soBuoi
ORDER BY soBuoi DESC

// Tìm tất cả các phòng học có ít nhất 1 học viên tham gia. Thông tin trả về bao gồm tên phòng học, tên học viên.

MATCH (hv:HocVien)-[:THAM_GIA]->(kh:KhoaHoc)-[:DIEN_RA_TAI]->(ph:PhongHoc)
RETURN ph.tenPhong AS tenPhongHoc, hv.ho + ' ' + hv.ten AS tenHocVien

// Tìm thông tin đồ án có ít nhất 5 học viên tham gia. Thông tin trả về bao gồm tên đồ án, học tên học viên, sắp xếp theo họ học viên.

MATCH (hv:HocVien)-[:LAM_DO_AN]->(da:DoAn)
WITH da, hv
ORDER BY hv.ho ASC
WITH da, collect(hv) AS hocViens
WHERE size(hocViens) >= 5
UNWIND hocViens AS hocVien
RETURN da.tenDA AS tenDoAn, hocVien.ho + ' ' + hocVien.ten AS tenHocVien
ORDER BY hocVien.ho ASC

// Tìm thông tin phòng có khóa học có mã là "1" đang diễn ra, thông tin trả về gồm tên khóa học, tên phòng.

MATCH (kh:KhoaHoc {maKH: 1})-[:DIEN_RA_TAI]->(ph:PhongHoc)
RETURN kh.ten AS tenKhoaHoc, ph.tenPhong AS tenPhongHoc

// Tìm những đồ án mà học viên số "1" tham gia, thông tin bao gồm tên học viên, tên dự án mà học viên tham gia, số giờ mà học viên làm việc trên dự án đó.

MATCH (hv:HocVien {maHV: 1})-[r:LAM_DO_AN]->(da:DoAn)
RETURN hv.ho + ' ' + hv.ten AS tenHocVien, da.tenDA AS tenDoAn, r.soGio AS soGioLamViec

// Tìm thông tin học viên làm việc trên đồ án số "12", thông tin trả về gồm tên học viên, số giờ làm việc, tên dự án tham gia.

MATCH (hv:HocVien)-[r:LAM_DO_AN]->(da:DoAn {maDA: 12})
RETURN hv.ho + ' ' + hv.ten AS tenHocVien, r.soGio AS soGioLamViec, da.tenDA AS tenDoAn

// Tìm thông tin học viên có tham gia các dự án cùng số giờ làm việc dự án đó, sắp xếp theo họ học viên, giới hạn trả về 4 kết quả.

MATCH (hv:HocVien)-[r:LAM_DO_AN]->(da:DoAn)
RETURN hv.ho + ' ' + hv.ten AS tenHocVien, da.tenDA AS tenDoAn, r.soGio AS soGioLamViec
ORDER BY hv.ho ASC
LIMIT 4

// Tìm thông tin học viên làm việc trên 2 đồ án. Thông tin bao gồm họ tên học viên, số lượng đồ án tham gia, sắp xếp giảm dần theo số lượng đồ án.

MATCH (hv:HocVien)-[:LAM_DO_AN]->(da:DoAn)
WITH hv, count(da) AS soLuongDoAn
WHERE soLuongDoAn = 2
RETURN hv.ho + ' ' + hv.ten AS tenHocVien, soLuongDoAn
ORDER BY soLuongDoAn DESC

// Tìm học viên nào có cùng họ và cùng tham gia đồ án, thông tin trả về bao gồm họ tên học viên, tên đồ án, sắp xếp theo họ học viên.

MATCH (hv1:HocVien)-[:LAM_DO_AN]->(da:DoAn)<-[:LAM_DO_AN]-(hv2:HocVien)
WHERE hv1.ho = hv2.ho AND hv1.maHV <> hv2.maHV
RETURN hv1.ho + ' ' + hv1.ten AS tenHocVien1, hv2.ho + ' ' + hv2.ten AS tenHocVien2, da.tenDA AS tenDoAn
ORDER BY hv1.ho ASC

// Tìm thông tin phòng đang diễn ra khóa học "chuyên đề phân tích dữ liệu" và các thông tin học viên đang tham gia khóa học này. Thông tin trả về bao gồm tên phòng, tên khóa học, họ tên học viên.

MATCH (hv:HocVien)-[:THAM_GIA]->(kh:KhoaHoc {ten: 'Chuyên đề phân tích dữ liệu'})-[:DIEN_RA_TAI]->(ph:PhongHoc)
RETURN ph.tenPhong AS tenPhongHoc, kh.ten AS tenKhoaHoc, hv.ho + ' ' + hv.ten AS tenHocVien
