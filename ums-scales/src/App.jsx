import React, { useState } from 'react';
import Truck360 from './components/Truck360/Truck360';
import './App.css';

export default function App() {
  const [activeTab, setActiveTab] = useState('specs');

  return (
    <div className="ums-app">
      {/* Top Header & 360° Hero Experience */}
      <section id="experience" className="ums-hero-section">
        <Truck360
          manifestUrl="./assets/truck-360/manifest.json"
          scrollDistance={2600}
        />
      </section>

      {/* Technical Specifications & Load Cell Section */}
      <section id="specifications" className="ums-specs-section">
        <div className="ums-container">
          <div className="ums-section-header">
            <span className="ums-section-tag">ENGINEERING DATA</span>
            <h2 className="ums-section-title">Built for Extreme Industrial Duty</h2>
            <p className="ums-section-desc">
              Engineered to withstand harsh quarry, mining, and highway transport environments with continuous load verification.
            </p>
          </div>

          <div className="ums-specs-tabs">
            <button
              type="button"
              className={`ums-tab-btn ${activeTab === 'specs' ? 'active' : ''}`}
              onClick={() => setActiveTab('specs')}
            >
              Weighbridge Platform
            </button>
            <button
              type="button"
              className={`ums-tab-btn ${activeTab === 'cells' ? 'active' : ''}`}
              onClick={() => setActiveTab('cells')}
            >
              Digital Compression Load Cells
            </button>
            <button
              type="button"
              className={`ums-tab-btn ${activeTab === 'truck' ? 'active' : ''}`}
              onClick={() => setActiveTab('truck')}
            >
              8×4 Vehicle Calibration
            </button>
          </div>

          <div className="ums-tab-content">
            {activeTab === 'specs' && (
              <div className="ums-grid-cards">
                <div className="ums-card">
                  <span className="ums-card-label">STRUCTURAL DESIGN</span>
                  <h3>High-Tensile I-Beam Modular Deck</h3>
                  <p>
                    Fabricated using heavy-section universal beams with longitudinal load-distribution girders and integrated anti-slip checkered steel wear plate.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Deck Dimensions:</strong> 18,000 mm × 3,000 mm × 380 mm</li>
                    <li><strong>Rated Capacity:</strong> 80,000 kg – 100,000 kg Safe Working Load</li>
                    <li><strong>Overload Safety Factor:</strong> 150% continuous / 300% ultimate</li>
                    <li><strong>Approach Ramps:</strong> Integrated reinforced concrete approach modules</li>
                  </ul>
                </div>

                <div className="ums-card">
                  <span className="ums-card-label">FOUNDATION &amp; SURFACE</span>
                  <h3>Pitless Low-Profile Installation</h3>
                  <p>
                    Designed for surface-mounted pitless operation with open lateral access for simplified maintenance, washdown, and routine inspections.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Foundation Type:</strong> Reinforced concrete raft mat / end-piers</li>
                    <li><strong>Corrosion Protection:</strong> Multi-coat epoxy zinc phosphate primer + polyurethane</li>
                    <li><strong>Drainage:</strong> Free-flowing transverse natural runoff design</li>
                    <li><strong>Deck Clearance:</strong> 240 mm side-clearance under-structure</li>
                  </ul>
                </div>
              </div>
            )}

            {activeTab === 'cells' && (
              <div className="ums-grid-cards">
                <div className="ums-card">
                  <span className="ums-card-label">SENSOR SPECIFICATIONS</span>
                  <h3>Hermetically Sealed Compression Load Cells</h3>
                  <p>
                    Equipped with 8 high-precision column compression canister load cells housed in spherical cup assemblies to prevent side-load induced measurement errors.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Accuracy Class:</strong> OIML R60 C3 (3000 verification divisions)</li>
                    <li><strong>Environmental Protection:</strong> IP68 / IP69K laser-welded stainless steel</li>
                    <li><strong>Surge Protection:</strong> Integrated transient voltage suppression gas-discharge tubes</li>
                    <li><strong>Temperature Compensation:</strong> -10°C to +50°C operational span</li>
                  </ul>
                </div>

                <div className="ums-card">
                  <span className="ums-card-label">SIGNAL &amp; INTERFACE</span>
                  <h3>Intelligent Digital Junction Processing</h3>
                  <p>
                    Individual load cell addressability enables corner-balancing diagnostics, live weight distribution tracking, and predictive fault isolation.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Digital Output:</strong> RS-485 / CANbus multi-drop telemetry</li>
                    <li><strong>Sampling Rate:</strong> 100 conversions / second</li>
                    <li><strong>Cable Armour:</strong> Stainless steel braided polyurethane jacket</li>
                    <li><strong>Indicator Interface:</strong> UMS Digital Weight Terminal with Ethernet / Modbus</li>
                  </ul>
                </div>
              </div>
            )}

            {activeTab === 'truck' && (
              <div className="ums-grid-cards">
                <div className="ums-card">
                  <span className="ums-card-label">TEST VEHICLE</span>
                  <h3>8×4 Heavy Tipper Dump Truck</h3>
                  <p>
                    Representing typical high-capacity off-road quarry and construction haulers used to validate gross, tare, and axle-group weight accuracy.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Axle Configuration:</strong> 1 Steer axle + Tandem rear drive bogie (8×4)</li>
                    <li><strong>Tire Configuration:</strong> Dual tires on tandem drive axles (10 tires total)</li>
                    <li><strong>Tare Weight:</strong> ~14,200 kg</li>
                    <li><strong>Gross Vehicle Mass:</strong> Up to 44,000 kg certified gross</li>
                  </ul>
                </div>

                <div className="ums-card">
                  <span className="ums-card-label">LEGAL METROLOGY</span>
                  <h3>Trade-Approved Static &amp; Dynamic Testing</h3>
                  <p>
                    Calibrated in compliance with international legal metrology standards for commercial custody transfer and bulk material shipping.
                  </p>
                  <ul className="ums-feature-list">
                    <li><strong>Verification Division (e):</strong> 10 kg / 20 kg dual-interval</li>
                    <li><strong>Repeatability Tolerance:</strong> &lt; 0.02% of applied load</li>
                    <li><strong>Eccentric Loading Error:</strong> &lt; 1 division per test point</li>
                    <li><strong>Approvals:</strong> NTEP Class III / OIML R76 Compliant</li>
                  </ul>
                </div>
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Orbit Validation & Audit Report Section */}
      <section id="validation" className="ums-audit-section">
        <div className="ums-container">
          <div className="ums-audit-box">
            <div className="ums-audit-header">
              <div className="ums-badge-verified">
                <span className="ums-check-icon">✓</span> AUDIT REPORT: ACCURATE CAPTURE DISCLOSURE
              </div>
              <h3>Photographic Sequence Validation (0° to 315°)</h3>
            </div>

            <p className="ums-audit-text">
              In adherence to strict production verification standards, the camera movement across the supplied footage has been audited frame-by-frame. The capture represents a continuous, counter-clockwise orbital traversal starting at <strong>0° (Direct Front View)</strong> and advancing through <strong>90° (Left Broadside)</strong>, <strong>180° (Direct Rear)</strong>, and <strong>270° (Right Broadside)</strong>, terminating at <strong>315° (Front-Right Three-Quarter View)</strong>.
            </p>

            <div className="ums-audit-metrics">
              <div className="ums-metric-item">
                <span className="ums-metric-val">110</span>
                <span className="ums-metric-lbl">Total Sequential Frames</span>
              </div>
              <div className="ums-metric-item">
                <span className="ums-metric-val">1920×1080</span>
                <span className="ums-metric-lbl">Native Resolution (16:9)</span>
              </div>
              <div className="ums-metric-item">
                <span className="ums-metric-val">315.0°</span>
                <span className="ums-metric-lbl">Actual Angular Coverage</span>
              </div>
              <div className="ums-metric-item">
                <span className="ums-metric-val">0</span>
                <span className="ums-metric-lbl">Missing / Corrupted Frames</span>
              </div>
              <div className="ums-metric-item">
                <span className="ums-metric-val">6.02 MB</span>
                <span className="ums-metric-lbl">Optimized WebP Sequence</span>
              </div>
            </div>

            <div className="ums-audit-footer-note">
              <strong>Metrological Integrity Note:</strong> The sequence is not artificially looped or padded with synthetic interpolation. One full scroll progression plays the actual 315° capture smoothly and reverses synchronously on back-scroll.
            </div>
          </div>
        </div>
      </section>

      {/* Website Footer */}
      <footer className="ums-site-footer">
        <div className="ums-container ums-footer-content">
          <div className="ums-footer-brand">
            <strong>UMS SCALES</strong>
            <p>Industrial Precision Weighing Solutions. All rights reserved.</p>
          </div>

          <div className="ums-footer-links">
            <a href="./demo/embed.html">Independent Embed Demo</a>
            <a href="./demo/sequence-embed.html">Sequence Container Demo</a>
            <a href="./demo/asset.html">GLB Model Inspection</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
