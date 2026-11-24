import React, { useEffect, useRef, useState, useCallback } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { useTruckFrames } from './useTruckFrames';
import './Truck360.css';

gsap.registerPlugin(ScrollTrigger);

/**
 * Truck360
 * High-performance, scroll-driven 360° interactive truck rotation viewer.
 * Powered by React, GSAP ScrollTrigger, and HTML5 Canvas.
 */
export default function Truck360({
  manifestUrl = './assets/truck-360/manifest.json',
  scrollDistance = 2500, // Pixels of scroll travel for the pinned section
  showHeader = true,     // Toggle top header bar
  showMilestones = true, // Toggle bottom milestone angle chips
  showHud = true,        // Toggle angle degree & frame counter HUD
  showOrbitBadge = true, // Toggle verified capture disclosure pill
  showCallout = true,    // Toggle viewpoint description callout
  showTools = true,      // Toggle right-hand tool stack (reset & fullscreen)
  showHints = true,      // Toggle bottom interaction hints
  initialMode = 'scroll',// 'scroll' | 'manual'
  isContinuous = true,   // Seamless infinite 360° wrapping in manual drag mode
  className = ''
}) {
  const containerRef = useRef(null);
  const pinSectionRef = useRef(null);
  const canvasRef = useRef(null);
  const animationFrameRef = useRef(null);
  const scrollTriggerRef = useRef(null);

  const {
    manifest,
    totalFrames,
    loadedCount,
    progressPercent,
    isInitialReady,
    isFullyLoaded,
    error,
    getFrame,
    milestones,
    orbitValidation,
    frameDimensions
  } = useTruckFrames(manifestUrl);

  const [currentFrameNum, setCurrentFrameNum] = useState(1);
  const [currentAngleDeg, setCurrentAngleDeg] = useState(0);
  const [activeMilestoneIndex, setActiveMilestoneIndex] = useState(0);
  const [interactionMode, setInteractionMode] = useState(initialMode); // 'scroll' | 'manual'
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const dragStartXRef = useRef(0);
  const dragStartFrameRef = useRef(1);

  // Maintain current frame in a mutable ref for requestAnimationFrame draw loop
  const frameRef = useRef(1);

  /**
   * Render frame onto canvas with high-DPI scaling and aspect-ratio preservation
   */
  const drawFrame = useCallback((frameIdx) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d', { alpha: false });
    if (!ctx) return;

    const img = getFrame(frameIdx);
    if (!img) return;

    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const rect = canvas.getBoundingClientRect();
    const targetWidth = Math.floor(rect.width * dpr);
    const targetHeight = Math.floor(rect.height * dpr);

    if (canvas.width !== targetWidth || canvas.height !== targetHeight) {
      canvas.width = targetWidth;
      canvas.height = targetHeight;
    }

    // Industrial dark background
    ctx.fillStyle = '#080b0f';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Compute aspect-fit dimensions
    const imgAspect = img.width && img.height ? img.width / img.height : 16 / 9;
    const canvasAspect = canvas.width / canvas.height;

    let drawW, drawH, drawX, drawY;

    if (canvasAspect > imgAspect) {
      // Canvas is wider than image: fit to height
      drawH = canvas.height;
      drawW = drawH * imgAspect;
      drawX = (canvas.width - drawW) / 2;
      drawY = 0;
    } else {
      // Canvas is taller than image: fit to width
      drawW = canvas.width;
      drawH = drawW / imgAspect;
      drawX = 0;
      drawY = (canvas.height - drawH) / 2;
    }

    // Draw the image crisply
    ctx.imageSmoothingEnabled = true;
    ctx.imageSmoothingQuality = 'high';
    ctx.drawImage(img, drawX, drawY, drawW, drawH);
  }, [getFrame]);

  // Request render whenever current frame changes or new images arrive
  const scheduleRender = useCallback((targetFrame) => {
    frameRef.current = targetFrame;
    if (animationFrameRef.current) {
      cancelAnimationFrame(animationFrameRef.current);
    }
    animationFrameRef.current = requestAnimationFrame(() => {
      drawFrame(frameRef.current);
    });
  }, [drawFrame]);

  // Re-draw initial frame when first frame is ready
  useEffect(() => {
    if (isInitialReady) {
      scheduleRender(frameRef.current);
    }
  }, [isInitialReady, scheduleRender]);

  // Handle window resize for canvas resolution adjustment
  useEffect(() => {
    const handleResize = () => {
      scheduleRender(frameRef.current);
    };
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, [scheduleRender]);

  /**
   * GSAP ScrollTrigger Setup
   */
  useEffect(() => {
    if (!totalFrames || totalFrames <= 1) return;

    const pinEl = pinSectionRef.current;
    if (!pinEl) return;

    // Scroll progress proxy object
    const scrollProxy = { progress: 0 };

    const st = ScrollTrigger.create({
      trigger: pinEl,
      start: 'top top',
      end: `+=${scrollDistance}`,
      pin: true,
      anticipatePin: 1,
      scrub: 0.1, // Near-instant 1:1 response with imperceptible smoothing
      onUpdate: (self) => {
        if (interactionMode !== 'scroll') return;

        const progress = Math.max(0, Math.min(1, self.progress));
        // Map 0.0 -> 1.0 to frame index 1 -> totalFrames
        const frameIndex = Math.round(1 + progress * (totalFrames - 1));
        const clampedFrame = Math.max(1, Math.min(totalFrames, frameIndex));

        setCurrentFrameNum(clampedFrame);

        // Approximate azimuth (0° to 315°)
        const angle = Math.round(progress * (orbitValidation?.actual_orbit_coverage_degrees || 315.0));
        setCurrentAngleDeg(angle);

        // Match milestone
        if (milestones && milestones.length > 0) {
          let closestIdx = 0;
          let minDiff = Infinity;
          milestones.forEach((m, idx) => {
            const diff = Math.abs(m.frame - clampedFrame);
            if (diff < minDiff) {
              minDiff = diff;
              closestIdx = idx;
            }
          });
          setActiveMilestoneIndex(closestIdx);
        }

        scheduleRender(clampedFrame);
      }
    });

    scrollTriggerRef.current = st;

    return () => {
      if (st) st.kill();
    };
  }, [totalFrames, scrollDistance, interactionMode, milestones, orbitValidation, scheduleRender]);

  /**
   * Milestone Click Handler: Smoothly scroll to milestone
   */
  const handleMilestoneClick = (milestone, index) => {
    if (!scrollTriggerRef.current || !totalFrames) return;
    const progress = (milestone.frame - 1) / (totalFrames - 1);
    const st = scrollTriggerRef.current;
    const targetScrollY = st.start + progress * (st.end - st.start);

    window.scrollTo({
      top: targetScrollY,
      behavior: 'smooth'
    });
    setActiveMilestoneIndex(index);
  };

  /**
   * Reset to Frame 1 (Front View)
   */
  const handleReset = () => {
    if (scrollTriggerRef.current) {
      window.scrollTo({
        top: scrollTriggerRef.current.start,
        behavior: 'smooth'
      });
    } else {
      scheduleRender(1);
      setCurrentFrameNum(1);
      setCurrentAngleDeg(0);
    }
  };

  /**
   * Fullscreen Toggle
   */
  const toggleFullscreen = () => {
    const el = pinSectionRef.current;
    if (!el) return;

    if (!document.fullscreenElement) {
      if (el.requestFullscreen) {
        el.requestFullscreen();
      } else if (el.webkitRequestFullscreen) {
        el.webkitRequestFullscreen();
      }
      setIsFullscreen(true);
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      }
      setIsFullscreen(false);
    }
  };

  /**
   * Manual Pointer Drag Scrubbing Handlers
   */
  const handlePointerDown = (e) => {
    if (interactionMode !== 'manual') return;
    setIsDragging(true);
    dragStartXRef.current = e.clientX || (e.touches && e.touches[0].clientX) || 0;
    dragStartFrameRef.current = currentFrameNum;
  };

  const handlePointerMove = (e) => {
    if (!isDragging || interactionMode !== 'manual') return;
    const clientX = e.clientX || (e.touches && e.touches[0].clientX) || 0;
    const deltaX = clientX - dragStartXRef.current;
    
    // Sensitivity: ~6px drag = 1 frame transition
    const frameDelta = -Math.round(deltaX / 6);
    
    let newFrame;
    if (isContinuous && totalFrames > 1) {
      // Seamless infinite 360° wrapping in both clockwise (dragging left) and counter-clockwise (dragging right)
      newFrame = (((dragStartFrameRef.current - 1 + frameDelta) % totalFrames) + totalFrames) % totalFrames + 1;
    } else {
      newFrame = Math.max(1, Math.min(totalFrames || 110, dragStartFrameRef.current + frameDelta));
    }
    
    if (newFrame !== currentFrameNum) {
      setCurrentFrameNum(newFrame);
      const progress = (newFrame - 1) / ((totalFrames || 110) - 1);
      const angle = Math.round(progress * (orbitValidation?.actual_orbit_coverage_degrees || 315.0));
      setCurrentAngleDeg(angle);
      scheduleRender(newFrame);
    }
  };

  const handlePointerUp = () => {
    setIsDragging(false);
  };

  const currentMilestone = milestones[activeMilestoneIndex] || null;

  return (
    <div className={`truck360-container ${className}`} ref={containerRef}>
      {/* Pinned Viewport Section */}
      <section className="truck360-pin-section" ref={pinSectionRef}>
        {/* Background Atmosphere */}
        <div className="truck360-backdrop"></div>

        {/* Top Header / Branding HUD */}
        {showHeader && (
          <header className="truck360-header">
            <div className="truck360-brand-lockup">
              <div className="truck360-logo-badge">UMS</div>
              <div className="truck360-brand-titles">
                <span className="truck360-brand-name">UMS SCALES</span>
                <span className="truck360-model-name">HEAVY-DUTY WEIGHBRIDGE 8×4</span>
              </div>
            </div>

            <div className="truck360-top-center">
              <h1 className="truck360-headline">PRECISION IN EVERY MOVEMENT.</h1>
              <p className="truck360-subheadline">Engineered for accuracy. Built for reliability.</p>
            </div>

            <div className="truck360-header-actions">
              <nav className="truck360-nav-anchors">
                <a href="#specifications" className="truck360-anchor-link">Specs</a>
                <a href="#validation" className="truck360-anchor-link">Orbit Audit</a>
                <a href="./demo/embed.html" className="truck360-anchor-link highlight">Embed API ↗</a>
              </nav>

              <div className="truck360-mode-controls">
                <button
                  type="button"
                  className={`truck360-mode-btn ${interactionMode === 'scroll' ? 'active' : ''}`}
                  onClick={() => setInteractionMode('scroll')}
                  title="Drive sequence via scroll"
                >
                  Scroll Mode
                </button>
                <button
                  type="button"
                  className={`truck360-mode-btn ${interactionMode === 'manual' ? 'active' : ''}`}
                  onClick={() => setInteractionMode('manual')}
                  title="Drag directly on truck to rotate"
                >
                  Drag Mode
                </button>
              </div>
            </div>
          </header>
        )}

        {/* Main Canvas Presentation Viewport */}
        <div
          className={`truck360-canvas-wrapper ${interactionMode === 'manual' ? 'draggable' : ''}`}
          onMouseDown={handlePointerDown}
          onMouseMove={handlePointerMove}
          onMouseUp={handlePointerUp}
          onMouseLeave={handlePointerUp}
          onTouchStart={handlePointerDown}
          onTouchMove={handlePointerMove}
          onTouchEnd={handlePointerUp}
        >
          <canvas ref={canvasRef} className="truck360-canvas" />

          {/* Loading Overlay */}
          {!isInitialReady && !error && (
            <div className="truck360-loading-overlay">
              <div className="truck360-spinner"></div>
              <div className="truck360-loading-text">
                <strong>CALIBRATING WEIGHBRIDGE ASSEMBLY</strong>
                <span>Buffering photographic sequence ({progressPercent}%)</span>
              </div>
              <div className="truck360-loading-bar-track">
                <div
                  className="truck360-loading-bar-fill"
                  style={{ width: `${progressPercent}%` }}
                ></div>
              </div>
            </div>
          )}

          {/* Error Alert */}
          {error && (
            <div className="truck360-error-overlay">
              <div className="truck360-error-icon">⚠</div>
              <strong>Unable to load truck sequence</strong>
              <p>{error}</p>
              <button
                type="button"
                className="truck360-btn-retry"
                onClick={() => window.location.reload()}
              >
                Retry
              </button>
            </div>
          )}

          {/* Precision Angle & Frame HUD */}
          {showHud && (
            <div className="truck360-angle-hud">
              <div className="truck360-hud-badge">
                <span className="truck360-hud-dot"></span>
                <span className="truck360-hud-angle">{currentAngleDeg}°</span>
                <span className="truck360-hud-label">AZIMUTH</span>
              </div>
              <div className="truck360-frame-counter">
                FRAME {String(currentFrameNum).padStart(3, '0')} / {totalFrames || 110}
              </div>
            </div>
          )}

          {/* Genuine Orbit Disclosure Pill */}
          {showOrbitBadge && (
            <div className="truck360-orbit-pill" title="Footage coverage verification">
              <span className="truck360-pill-icon">ℹ</span>
              <span>VERIFIED CAPTURE: 315° ORBITAL SWEEP (0°–315°)</span>
            </div>
          )}

          {/* Active Milestone Title Overlay */}
          {showCallout && currentMilestone && (
            <div className="truck360-view-callout">
              <span className="truck360-callout-tag">VIEWPOINT</span>
              <h2 className="truck360-callout-title">{currentMilestone.label}</h2>
              <p className="truck360-callout-desc">{currentMilestone.desc}</p>
            </div>
          )}

          {/* Right Floating Quick Action Tools */}
          {showTools && (
            <aside className="truck360-tool-stack">
              <button
                type="button"
                className="truck360-tool-btn"
                onClick={handleReset}
                title="Reset view to front"
                aria-label="Reset view"
              >
                ↺
              </button>
              <button
                type="button"
                className="truck360-tool-btn"
                onClick={toggleFullscreen}
                title="Toggle fullscreen"
                aria-label="Toggle fullscreen"
              >
                {isFullscreen ? '✕' : '⛶'}
              </button>
            </aside>
          )}
        </div>

        {/* Bottom Milestone Angle Track Bar */}
        {showMilestones && (
          <footer className="truck360-footer">
            <div className="truck360-milestones-track">
              {milestones.map((m, idx) => (
                <button
                  key={m.frame}
                  type="button"
                  className={`truck360-milestone-chip ${
                    idx === activeMilestoneIndex ? 'active' : ''
                  }`}
                  onClick={() => handleMilestoneClick(m, idx)}
                >
                  <span className="truck360-chip-angle">{m.angle_deg}°</span>
                  <span className="truck360-chip-label">{m.label}</span>
                </button>
              ))}
            </div>

            {/* Interactive Guidance Bar */}
            {showHints && (
              <div className="truck360-interaction-hint">
                {interactionMode === 'scroll' ? (
                  <span>
                    <span className="truck360-scroll-arrow">↓</span> Scroll down to rotate truck & weighbridge
                  </span>
                ) : (
                  <span>⟷ Click and drag horizontally to spin the truck</span>
                )}
                <span className="truck360-buffer-status">
                  {isFullyLoaded
                    ? 'All 110 frames buffered in memory'
                    : `Buffering frames (${loadedCount}/${totalFrames})`}
                </span>
              </div>
            )}
          </footer>
        )}
      </section>
    </div>
  );
}
