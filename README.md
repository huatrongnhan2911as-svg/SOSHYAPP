# 🍔 SOSHY Restaurant - Online Food Ordering System
> **Dự án:** Xây dựng ứng dụng đặt món ăn trực tuyến tích hợp thanh toán cho nhà hàng SOSHY.

Dự án này là một giải pháp chuyển đổi số toàn diện cho nhà hàng SOSHY, cho phép khách hàng duyệt thực đơn, đặt món và thanh toán trực tuyến một cách nhanh chóng và bảo mật.

---

## 👥 Thành viên nhóm & Phân công nhiệm vụ (Team & Roles)

Dự án được thực hiện bởi nhóm 5 thành viên với sự phối hợp chặt chẽ giữa các vai trò nghiệp vụ và kỹ thuật:

| Thành viên | Vai trò | Trách nhiệm chính |
| :--- | :--- | :--- |
| **Ngân** | Business Analyst (BA) | Khảo sát quy trình nghiệp vụ, lấy yêu cầu từ nhà hàng SOSHY. |
| **Trung** | Business Analyst (BA) | Đặc tả yêu cầu hệ thống (SRS), phân tích luồng thanh toán. |
| **Thanh** | UI/UX Designer | Thiết kế giao diện (Figma), trải nghiệm người dùng và bộ nhận diện SOSHY. |
| **Nhân** | Fullstack Developer | Xây dựng Backend (API, Database) và Frontend (Giao diện người dùng). |
| **Uy** | Quality Assurance (BA/QA) | Kiểm thử quy trình đặt hàng, đảm bảo tính đúng đắn của logic nghiệp vụ. |

---

## 🕒 Tiến độ thực hiện (Timeline)

Dự án được triển khai từ ngày **23/03** đến ngày **29/04** với các mốc quan trọng:

- **Tuần 1 (23/03 - 29/03):** - [BA] Khảo sát thực tế tại nhà hàng SOSHY.
  - [BA] Thống nhất danh mục món ăn và quy trình thanh toán.
- **Tuần 2 (30/03 - 05/04):**
  - [UI/UX] Hoàn thành thiết kế Wireframe và Mockup (Dark Mode chủ đạo).
  - [Dev] Thiết kế sơ đồ thực thể mối quan hệ (ERD) cho Database.
- **Tuần 3 & 4 (06/04 - 20/04):**
  - [Dev] Code chức năng Giỏ hàng, Menu động và Quản lý đơn hàng.
  - [Dev] Tích hợp cổng thanh toán trực tuyến (VNPay/MoMo).
- **Tuần 5 (21/04 - 29/04):**
  - [BA/QA] Kiểm thử toàn bộ hệ thống (UAT).
  - [Team] Hoàn thiện tài liệu hướng dẫn và đóng gói mã nguồn.

---

## 🚀 Tính năng cốt lõi (Key Features)

- **Smart Menu:** Hiển thị món ăn theo danh mục, có bộ lọc theo giá và độ phổ biến.
- **Real-time Cart:** Giỏ hàng cập nhật tức thì, cho phép tùy chỉnh ghi chú cho đầu bếp.
- **Secure Payment:** Tích hợp thanh toán qua QR Code hoặc thẻ ngân hàng nội địa.
- **Order Tracking:** Khách hàng theo dõi trạng thái đơn hàng (Đang chuẩn bị -> Đang giao).
- **Admin Dashboard:** Trang quản trị cho nhà hàng quản lý doanh thu, món ăn và đơn hàng.

---

## 🛠 Công nghệ sử dụng (Tech Stack)

- **Frontend:** React.js / Next.js, Tailwind CSS.
- **Backend:** Node.js (Express) hoặc PHP (Laravel).
- **Database:** MySQL hoặc PostgreSQL.
- **Payment API:** VNPay Sandbox / Stripe.
- **Design:** Figma.

---

## 📊 Biểu đồ tiến độ (Gantt Chart)

```mermaid
gantt
    title Lộ trình dự án SOSHY (23/03 - 29/04)
    dateFormat  YYYY-MM-DD
    section Nghiệp vụ & Thiết kế
    Lấy yêu cầu (Ngân, Trung)   :2026-03-23, 7d
    Thiết kế UI/UX (Thanh)      :2026-03-30, 7d
    section Phát triển & Test
    Lập trình Backend & FE (Nhân):2026-04-06, 15d
    Tích hợp Thanh toán         :2026-04-15, 6d
    Kiểm thử & Fix bug (Uy)     :2026-04-21, 7d
    section Hoàn thiện
    Nộp dự án                   :milestone, 2026-04-29, 0d
