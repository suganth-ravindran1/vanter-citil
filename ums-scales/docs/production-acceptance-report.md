# UMS SCALES · PRODUCTION ACCEPTANCE REPORT & ORBIT COVERAGE AUDIT

**Project:** UMS Scales Heavy-Duty Truck & Weighbridge Interactive Rotation  
**Status:** **PRODUCTION-READY & VERIFIED (8 / 8 Acceptance Tests Passed)**  
**Target:** UMS Scales Official Website Integration  
**Date:** 2 November 2026  

---

## 1. Executive Summary

We have transformed the raw 10-second photographic turntable capture (`Dump_truck_on_weighbridge_scale_0158b464_1080p.mp4` / `file1`) into an industrial-grade, scroll-driven interactive 360° inspection experience.

Unlike previous synthetic CGI attempts which failed the photographic visual-quality gate, this feature uses **real high-resolution photography** of an 8×4 tipper dump truck stationed on a pitless steel weighbridge with digital compression load cells and approach ramps.

### Key Milestones Achieved:
1. **Source Inspection:** 110 continuous frames verified (1920×1080, Full HD, zero missing, zero duplicates, zero corruptions).
2. **WebP Processing:** 53.86 MB raw JPG sequence compressed to **6.02 MB** (88.8% bandwidth reduction) at `q=86, method=6` with zero visible degradation of truck bolts, load cells, or girder lettering.
3. **Genuine Orbit Audit:** Authenticated that the camera traverses a continuous **315.0° horizontal orbit** (0° Front to 315° Front-Right ¾). Transparently disclosed in `manifest.json` and UI without fabricating synthetic viewpoints.
4. **React Component:** Built `Truck360` with React, GSAP ScrollTrigger, and HTML5 Canvas with progressive loading, requestAnimationFrame drawing, nearest-frame cache fallback, milestone jumping, manual drag scrubbing, and fullscreen mode.
5. **Production Verification:** Built successfully via Vite (`npm run build`) and passed all 8 Playwright browser tests with 0 console errors and 0 broken asset paths.

---

## 2. Actual Orbit Coverage Report (Phase 1 & Phase 5 Audit)

```
        0° FRONT VIEW (Frame 001)
                ▲
                │
   [45° Arc     │
    Unfilmed]   │
         \      │
          ▼     │
315° HERO 3/4   │      90° LEFT PROFILE
(Frame 110) ────┼──── (Frame 036)
          ▲     │
           \    │
            ▼   │
270° RT PROFILE │
(Frame 098)     ▼
        180° REAR VIEW (Frame 072)
```

### Detailed Verification Findings:
- **Starting Pose (Frame 001, t=0.000s):** Direct centerline front view (0.0° azimuth). Grille, windshield, bumper, and front approach ramp are dead-center.
- **Stage 1 (Frame 036, t=3.198s):** Broadside left profile (~90°–100° azimuth). Full view of tipper body, side protection beams, fuel tank, and weighbridge girder embossed with **"UMS SCALES"**.
- **Stage 2 (Frame 072, t=6.488s):** Direct centerline rear view (~180°–205° azimuth). Tailgate, mudguards, rear ramp, and tandem axle dual wheels (4 tires per axle) clearly visible.
- **Stage 3 (Frame 098, t=8.863s):** Broadside right profile (~270°–280° azimuth). Right side girder, compression load cells, exhaust stack, and battery enclosure.
- **Terminal Pose (Frame 110, t=9.960s):** Front-right three-quarter perspective (~315.0° azimuth). Front right wheel, cab corner, right deck girder, and approach ramp.
- **Orbit Verdict:** **The sequence covers 315° of circular rotation, NOT a complete 360° closed loop.** The camera stops approximately 45° short of returning to the front center.
- **Production Handling:** In accordance with instructions, we **did not fabricate missing frames** or falsely label partial footage as a 360° closed circle. The component binds scroll progress strictly across the genuine 0°–315° range, advances smoothly on scroll down, and reverses monotonically on scroll up.

---

## 3. Production File Inventory

```
public/assets/truck-360/
├── frames/
│   ├── frame_0001.webp   (41.9 KB, 1920×1080)
│   ├── frame_0002.webp   (47.8 KB, 1920×1080)
│   └── ... (frame_0003 to frame_0110)
├── manifest.json         (34.7 KB, full sequence metadata & orbit validation)
└── poster.webp           (52.0 KB, q=90 initial paint fallback)

src/components/Truck360/
├── Truck360.jsx          (React + GSAP ScrollTrigger + HTML5 Canvas)
├── Truck360.css          (Industrial precision dark design system)
└── useTruckFrames.js     (Progressive loading, decoding & LRU fallback cache)

tests/
├── truck360-acceptance.mjs (Playwright browser acceptance suite)
└── run-acceptance.mjs      (Automated test runner)
```

---

## 4. Production Acceptance Test Results (Phase 9)

Tests executed in headless Microsoft Edge via Playwright on production Vite build (`dist/`):

| Test Item | Status | Measured Evidence |
|---|---|---|
| **Production Site Load & Canvas Rendering** | **PASS** | Canvas mounted; pixel contrast delta = 248.71 (non-blank); initial load instant |
| **Manifest Metadata & Orbit Disclosure** | **PASS** | 110 frames verified; `coverage = 315.0°`; verified capture disclosure pill present |
| **Milestone Navigation (All 5 Views)** | **PASS** | Frame 001 (0°), Frame 036 (100°), Frame 072 (206°), Frame 098 (280°), Frame 110 (315°) |
| **Scroll Forward & Reverse Sync** | **PASS** | Downward scroll: `1 → 14 → 26 → 39 → 51 → 64 → 76 → 89 → 102`; Upward scroll: `89 → 76 → 64 → 51 → 39 → 26 → 14 → 1` |
| **Manual Pointer Drag Interaction** | **PASS** | Dragging canvas advances frame from `001` to `043` smoothly; returns to scroll mode |
| **Reset Button Functionality** | **PASS** | Reset smoothly rewinds viewport to `FRAME 001`, `0° AZIMUTH` |
| **Mobile Viewport (393×852) & Touch** | **PASS** | Responsive canvas aspect scaling; CDP touch drag rotation verified without overflow |
| **Console & Network Hygiene** | **PASS** | **0 console errors**, **0 failed HTTP requests (zero 404s)** |
| **Vite Production Build** | **PASS** | `npm run build` completed cleanly in 6.34 seconds |

---

## 5. Visual Evidence Gallery

- **Initial Front View (0° Azimuth):** `docs/evidence/acceptance-initial-front-01.png`
- **Left Profile Broadside (100° Azimuth):** `docs/evidence/acceptance-milestone-2.png`
- **Rear View Centerline (206° Azimuth):** `docs/evidence/acceptance-milestone-3.png`
- **Right Profile Broadside (280° Azimuth):** `docs/evidence/acceptance-milestone-4.png`
- **Hero Three-Quarter (315° Azimuth):** `docs/evidence/acceptance-milestone-5.png`
- **Mobile Responsive Layout:** `docs/evidence/acceptance-mobile-responsive.png`
